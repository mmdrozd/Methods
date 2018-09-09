"""
MacOS VERSION

Description: This script starts with a csv file of names and other public info about scholars, and augments it with results from Google Scholar searches for those scholars
Authors: Alex Kaufman (AK), Chris Carroll (CDC)
Original Date: 2015/06/12
Latest: 2017-05-01

Directories
./working
  files created and destroyed as the script runs
  this is where the cumulated information from previous runs of the script are cumulated
./input   
  files taken in by code in order to do its work, mainly:
  auth_names_update.csv (a spreadshet with the names of the scholars whose information is sought)
  auth_changes.csv (tweaks to make the Google Scholar searches work for authors with problematic names)
  newauthinfo.csv (names of persons who did not appear in the original list but should be added)
./results
  output:
    ByName - the commands generated and their results for each person 
    Global - combined information on all scholars in the list
./code
  where this script and other related code resources reside

OPERATION:
First run requires setup; see README.md for details; accomplished by running doAll.sh
Subsequent runs from the command line can be done using doAll.sh, or directly via running this script (e.g., for debugging, in Spyder)

FUNCTIONALITY NOTES:
note: If edited in Excel, the auth_names_update.csv file must be saved as "Windows CSV" when running on MAC (Not "MS DOS "format) !!!
note: Program assumes it is running on a unix system (Mac or linux); windows users should reconsider their poor life choices
note: Google Scholar tries to block bots!  If you loop over names[:>=10] or run the script repeatedly, 
note: at some point Google will begin blocking searches from you!
note: The risk of this can be diminished by using an anonymizer (e.g., NetShade, on the Mac) that automatically switches
note: from one IP address to another at some interval.  In practice, this program is configured under the 
note: assumption that NetShade (or some other IP switcher) is changing the IP address every minute.
note: Even so, Google seems to be able to detect patterns in your searches and block you if you do similar searches even from
note: different IP's.  Below, this is handled by introducing some inconsequential randomness in the searches.
note: After some period of time you will be forgiven and Google will let you search again
note: If Google Scholar returns no results, or accuses you of being a bot, the code will wait for a while then try again
note: For further info and workarounds, see the github issue #52 (https://github.com/ckreibich/scholar.py/issues/52) and related resources
"""

import csv
from   subprocess import call
from   subprocess import check_output
import os
import random
import time
import pandas
import numpy as np
import shutil

pathCode = os.getcwd() # filepath of this script's directory
os.chdir("..")         # filepath above the code is the root 
path     = os.getcwd()  

scholarMethRun = 'python '+pathCode+'/scholar-Methods.py -ddd ' # Run the original, unmodified version of scholar.py
scholarOrigRun = 'python '+pathCode+'/scholar.py         -ddd ' # Run the version modified to capture the url and results

# Most of the constants defined below are needed to get around Google's bot detection algorithms
# Set num_art = 0 to retrieve default number of articles (which seems to be only one)
num_art = 10                        # max number of articles to return per author; Google starts suspecting you are a robot (which you are!) if this is more than 10; ckreibich promises, in issue 72, to fix soon 
mins_between_searches =1           # Minimum number of minutes to wait between successive individual searches 
mins_to_wait_after_suspicion   = 1 # If we think that Google suspects us, how many mins do we wait before making another request?
mins_to_wait_after_503  = 3        # A 503 error likely reflects a failure of the server to connect; wait until the next server comes up
mins_to_wait_after_accusation = 10 # If Google has explicitly accused us of being a robot, start waiting this many minutes before trying again (actually, it starts by doubling this figure)
argstringMakeSkip = True           # If not true, do not skip construction of the search string -- useful for debugging 
# Start!

# Ensure existence of directories that will contain the results; create them if they are not there 
if not os.path.isdir(path+"/results"):  
    os.makedirs(path+"/results")
if not os.path.isdir(path+"/results/ByName"): 
    os.makedirs(path+"/results/ByName")
if not os.path.isdir(path+"/results/Global"): 
    os.makedirs(path+"/results/Global")
if not os.path.isdir(path+"/inputs"):
    print 'Cannot run the program without inputs.  Put inputs in proper locations and try again.'
    sys.exit()

# read author data and create the list of names
authData   = pandas.read_csv(path+'/working/auth_names_update.csv',header=0,index_col=False) # doAll.sh script that runs auth_lookup_update should copy ./inputs/auth_names_update.csv to ./working/auth_names_update.csv
changeData = pandas.read_csv(path+'/inputs/auth_changes.csv'      ,header=0,index_col=False) # tricksy file: After we implement the change requested, we rewrite the file to change the update request from 1 to 0
newAuthors = changeData.query('newAuthor == 1') # new authors who are not in auth_names_update.csv; we can also add new authors in the newauthors.csv file -- that option should probably be eliminated as superfluous
modAuthors = changeData.query('newMod == 1')    # authors whose searches need to be tweaked
# merge information from the baseline set of author names with any augmentation of that info contained in changeData or newAuthors
# 'right' means that data from the second overrides or replaces data from the first source, as desired in this case
bothData  = pandas.DataFrame.merge(authData, changeData,    left_on='nameid', right_on='nameid', how='left')
bothData  = bothData.append(newAuthors   , ignore_index=True)
names     = list(bothData.nameid) # The list of names of all people to retrieve information on


# Clear out the log of scholar.py commands that returned no results the last time the program was run
if os.path.isfile(path+"/results/returned_no_results.log"):
  os.system("rm  "      +path+"/results/returned_no_results.log")
  os.system("type nul >"+path+"/results/returned_no_results.log")

# define bibinfo as a csv.writer object (so that when data has been constructed it can be written out)
# bibinfo.csv accumulates the set of all the article references that have been returned by Google Scholar
citesCol = 3 # Column that will contain the number of citations, so the elements in that column can be tallied later to produce a total
if os.path.isfile(path+"/results/Global/bibinfo.csv"): 
    print str(path+"/results/Global/bibinfo.csv already exists; moving it to backup file).")
    os.system("mv "+path+"/results/Global/bibinfo.csv "+path+"/results/Global/bibinfo.old")

print "Creating ./results/Global/bibinfo.csv, which will contain all references retrieved by Google Scholar."
bibinfoFile = open(path+"/results/Global/bibinfo.csv", 'w+')
bibinfo = csv.writer(bibinfoFile,quotechar = '"',quoting=csv.QUOTE_ALL)

bibinfo.writerow(['title', 'year', 'authors', 'num_citations', 'url_citations', 
                      'nameFull',
                      'nameSort', 'url', 'num_versions', 'cluster_id', 'url_pdf', 'url_versions', 'url_citation', 'excerpt',
                      'name_Last', 'name_Frst', 'name_Midl'
])

# authinfo.csv is our cache for the things we want to keep track of
if not os.path.isfile(path+"/working/authinfo.csv"):  # If authinfo.csv does not exist yet 
    print "Creating ./working/authinfo.csv, which will contain a summary of the results for each author."
    with open(path+"/working/authinfo.csv", 'w+') as authinfoFile:
      authinfo = csv.writer(authinfoFile,quotechar = '"',quoting=csv.QUOTE_ALL)
      authinfo.writerow(['nameOrig'
                         ,'cites_of_top_papers' , 'url_scholar_local'
                         , 'urlFromFileHYPERLINK','urlScholar','googleSearchCV']) 

##########################
# Main loop is over names; for each name, construct scholar.py search query and (re)construct outputs
# Debugging tip: insert a number into names[:n] to only loop through the first n authors (like, 1!)
for name in names[:]:                                                      # A lot of this code could go away if the auth_info.csv file could just come with last, first, and middle names directly
    nameOrig = name                                                        # original name (used to merge with author data later)
    authRowNumber = np.where(bothData['nameid']==name)[0]                  # pull the row number that corresponds to the current author from the author ranking data in dataframe 'bothData'
    # Could not discover a way to automate the search for Google Scholar unique identifiers -- though maybe scholarly.py will be a good method for a future revision
    # These are obtained now by cut-and-paste from the url that brings up the person's self-curated Google Scholar page
    # A hand-collected set of them should be accumulated in auth_changes.csv file in the column ScholarID
    urlScholar = ''                                                        # Start by assuming there is no Google ScholarID url
    scholarIDStr = '%s' % bothData.loc[authRowNumber]['ScholarID'].iloc[0] # Amazing how hard it is to extract a string from a data frame dtype object!
    # If the entry was empty, pandas calls it NaN; when converted into a string by the above command, that becomes nan
    if scholarIDStr != 'nan': # If it has been entered by hand
         urlScholar = '=HYPERLINK("http://scholar.google.com/citations?hl=en&user=%s","Self-Curated")' % scholarIDStr
         # Now collect any tweaks to the Google Scholar search; they are stored in the merged data file
    allOf  = bothData.loc[authRowNumber]['allOf']  # to be a hit, the item must contain all  of the words in allOf
    someOf = bothData.loc[authRowNumber]['someOf'] # to be a hit, the item must contain some of the words in someOf
    noneOf = bothData.loc[authRowNumber]['noneOf'] # to be a hit, the item must contain none of the words in noneOf
    authorNameFix = bothData.loc[authRowNumber]['authNameFix'] # assign Author Name Fix, for authors whose name in the original list is not the one we want to canonicalize for them
    authorNameFix = list(authorNameFix)
    authorNameFix = authorNameFix[0]
    newMod = bothData.loc[authRowNumber]['newMod'] # variable indicating whether the supplemental info for this person has already been processed in a search
    newModList = list(newMod)                      # Turn it into a list object
    #import pdb; pdb.set_trace()
    newModList = newModList[0]                     # This turns it into a 0 or 1 (true or false)
    authSearchMods = 1                             # assign a dummy to indicate that we need to modify the existing search

    if allOf.isnull().item() & someOf.isnull().item() & noneOf.isnull().item(): # Strange .item() suffix needed because pandas objects are weird
         authSearchMods = 0 # 0 if all modification variables are empty; that is, no modifications are needed
    nameClean = "".join(name)                       #removes brackets and other problem characters from names
    nameSplit = name.split(",")                     #splits name at comma
    name_FrstMidl = "".join(nameSplit[1:2])         #assign first-and-middle names
    name_Last = "".join(nameSplit[0:1])             #assign last name
    # Handle cases where the last name has a space in it (e.g., von Neumann)
    name_Last1 = "".join(name_Last.split(" ")[0:1]) # First of space-separated last names
    name_Last2 = "".join(name_Last.split(" ")[1:2]) # Second of space-separated last names
    if not name_Last2 == "":                        # if name_Last2 is empty, it evaluates to false and this does not get executed
      name_Last   = str(name_Last1+"-"+name_Last2)

    # Handle cases where the last name has an apostrophe (e.g., O'Brien)
    name_Last1 = "".join(name_Last.split("'")[0:1])    # Before the apostrophe
    name_Last2 = "".join(name_Last.split("'")[1:2])    # After  the apostrophe
    if not name_Last2 == "":                           # if name_Last2 is empty, it evaluates to false and this does not get executed
      name_Last   = str(name_Last1+"-"+name_Last2)     # Add a dash between the first and second last names
    name_Frst = "".join(name_FrstMidl.split(" ")[1:2]) #pick out only first name (remove mid names)
    name_Midl = "".join(name_FrstMidl.split(" ")[2:3]) #pick out middle name if it exists
    nameFull  = name_Frst # Build full name
    if not name_Midl == "": # If the middle name is not empty, add it 
        nameFull = str(name_Frst+" "+name_Midl)
    nameFull = str(nameFull +" "+name_Last)               # Full name is accumulated first and (if existing) middle plus last
    nameShrt = str(name_Frst+" "+name_Last)               # Short name omits middle
    nameSort = str(name_Last+"_"+name_Frst+"_"+name_Midl) # Include name_Midl even if empty because it's useful information that it's empty
    nameFile      = str("results/ByName/"+nameSort)
    nameFileCSV   = path+'/%s.csv'   % nameFile # The bsv file will be converted to a 'true' csv file with this name
    nameFileCMD   = path+'/%s.cmd'   % nameFile # Capture and save the exact command line using scholar.py that produces the results
    nameFileURL   = path+'/%s.url'   % nameFile # Capture the url that scholar.py produces as output from the command-line input
    nameFileCites = path+'/%s.cites' % nameFile # Capture in a file the total number of citations that the author has received
    nameFileBIB   = path+'/%s.bib'   % nameFile # BibTeX list of references
    skipped = 0                                 # Default not to skip the person with this name ...
    if os.path.isfile(nameFileCSV) and newModList != 1:  # ... is overridden if the person already exist and the auth_changes file has told us to update them ...
      skipped = 1
      print ''
      print 'Skipping %s because data already constructed and auth_changes.csv did not indicate that it should be updated.' % nameFull
      print ''

    if (skipped == 1) or (not argstringMakeSkip == False):
      #make argstring with bash command that will query google scholar and save the results
      repeatUntilSuccess = 0 # Keep trying to get the data for this person
      while (repeatUntilSuccess == 0):
 
          repeatUntilSuccess = 1 # Assume we'll succeed until evidence of failure changes our mind
          # Google identifies you as a robot if you do successive searches that are too similar to each other, so add a bit of inconsequential randomness
          afterYear = str(2003+random.randrange(1,4)) # Will be used if a specific year has not been specified in auth_changes.csv
          SearchAfterYear = bothData.loc[authRowNumber]['SearchAfter']
          if not SearchAfterYear.isnull().item(): # The item is null if the auth_changes file did not specify a start year for the search
              afterYear = '%s' % bothData.loc[authRowNumber]['SearchAfter'].iloc[0].astype(int) # Absurd how hard it is to extract the year from the dataframe
          else:
              afterYear = '2007'
 
          # Now collect any tweaks to the Google Scholar search -- they are stored in the merged data file
          argstring = ''
          cookieFileName = '%s/inputs/cookies.txt' % path                                        # To recover from accusation of being a robot, browse to scholar.google.com, paste in a url that led to accusation, prove you're not a robot, and then export the cookies to this file
          argstring = argstring +' --cookie-file %s ' % cookieFileName                           # These are paired because --citation only works if you are logged into a Google Scholar account (according to your cookie file) 
          argstring = argstring +' --after '+afterYear
          urlScholar = ''                                                                        # Start by assuming we do not have a url
          scholarIDStr = '%s' % bothData.loc[authRowNumber]['ScholarID'].iloc[0]                 # Extract a string from a data frame dtype object
          if scholarIDStr != 'nan':                                                              # If the entry was empty, pandas calls it NaN; converted into a string by the above command, it becomes nan
              urlScholarRaw = 'http://scholar.google.com/citations?hl=en&user=%s' % scholarIDStr # Creates the url
              urlScholar = '=HYPERLINK("%s","Self-Curated")' % urlScholarRaw                     # Creates a spreadsheet command that, in Excel, will generate a clickable link
          if authSearchMods == 0 and urlScholar != "":                                           # this is the argstring build sequence executed if NO additional search criteria are in auth_changes
              if random.randrange(0,2) == 1:                                                     # Oddly, random.randrange(0,2) only yields either 0 or 1 as its output; so this is 50-50
                  argstring = argstring+ ' --no-patents'                                         # Randomly include --no-patents to generate variation in the query so we don't look like a robot
              if num_art > 0:                                                                    # if 0, do not specify a count of articles 
                  argstring = argstring+ ' --count %s' % num_art                                 # --count specifies the number of articles to retrieve; if num_art = 0, do not give this as an argument to scholar.py
              argstring = argstring +' --author "%s %s"  ' % (name_Frst, name_Last)              # Unfortunately, Google scholar interprets this as a list of names rather than the name of a single author
              if random.randrange(0,2) == 1:
                  argstring = argstring+ ' --all "%s %s"' % (name_Frst, name_Last) # Insisting that both first name and last name exist somewhere helps narrow it down
          else:                                                                    #argstring build sequence if there is user-specified search info, used in place of robotically generated
              allOf  = list(allOf)
              allOf  = allOf[0]
              if pandas.isnull(allOf) == True:
                  allOf = ' '
              someOf = list(someOf)
              someOf = someOf[0]
              noneOf = list(noneOf)
              noneOf = noneOf[0]
              if pandas.isnull(noneOf) == True:
                  argstring = argstring+ ' --no-patents ' 
              else:
                  argstring = argstring+ ' --no-patents --none "%s" ' % noneOf
              if num_art > 0:
                  argstring = argstring+ ' --count %s' % num_art # can be modified, if robot-detection problems, to get a random count of articles below num_art
              if pandas.isnull(authorNameFix) != True:
                  argstring = argstring +' --author "%s"  ' % name_Last # Usually when we need to fix the author's name it is because there are authors with similar names
                  argstring = argstring +' --phrase "%s"  ' % authorNameFix # A solution that usually helps is to insist that the author's entire name be present as an exact phrase
              else:
                  argstring = argstring +' --author "%s %s"  ' % (name_Frst, name_Last)
              argstring = argstring+ ' --all "%s" ' % allOf  
              if pandas.isnull(someOf) != True:                             # If there are some someOf words
                  argstring = argstring + ' --some "%s"' % someOf
                  
          argstringBIB = argstring +' --citation bt '                          # BibTeX citation list and csv-header are alternatives, they can't be gotten together 
          argstringCSV = argstring +' --csv-header  '                          # 
          print ""
          print scholarMethRun+argstringCSV  # show the user what the command will be to retrieve the CSV    results
          print 
          print scholarOrigRun+argstringBIB  # show the user what the command will be to retrieve the BibTeX results
          print ""
          nameFileCSVFixed=nameFileCSV
          nameFileCSVFixed+="fix"
          # Construct one-liners to do everything that needs to be done from the bash prompt
          scholarMethCmd = '%s %s' % (scholarMethRun,argstringCSV)
          scholarOrigCmd = '%s %s' % (scholarOrigRun,argstringBIB)
          # The file created is actually bar separated; process it to make it a real csv file
          getAndProcessCSV = scholarMethCmd + '> %s ; %s/make-into-proper-csv-file.sh %s > %s ; mv %s %s' % (nameFileCSV,pathCode,nameFileCSV,nameFileCSVFixed,nameFileCSVFixed,nameFileCSV)
          getAndArchiveBIB = scholarOrigCmd + '> %s'                                                      % nameFileBIB
#          quitFireFox = 'osascript -e \'quit app \"FireFox\"\''
#          os.system(quitFireFox) # Close FireFox so that the fact that the file is open won't prevent it from being deleted
#          time.sleep(5) # Give FireFox time to quit
          print 
#          print getAndProcessCSV
          print 
# Delete previous results
          if (skipped == 0):    # If processing of this person is not to be skipped
              if os.path.isfile(  path+"/working/results.html"):
                  os.system("rm "+path+"/working/results.html") 
              if os.path.isfile(  path+"/working/search.cmd"):   # Delete the last search command
                  os.system("rm "+path+"/working/search.cmd") 
              if os.path.isfile(  path+"/working/url.html"):     # Delete the url corresponding to the last search
                  os.system("rm "+path+"/working/url.html") 

              os.system(getAndProcessCSV) # pass bash code for retrieving scholar data to shell, where it creates ./results.html, ./results/ByName/[nameFile].csv
              os.system(getAndArchiveBIB) # 
              if os.path.isdir(path+"/working"): # Move the prior results generated by scholar.py to the working directory
                  os.chdir(path)
                  resultsFrom = '%s/results.html' % path
                  resultsTo   = '%s/working/results.html' % path
                  if os.path.exists(resultsFrom):
                       mvResults = 'mv %s %s' % (resultsFrom,resultsTo)
                       print 'Moving '+mvResults
                       os.system(mvResults)
              
                  urlFrom = '%s/url.html' % path
                  urlTo   = '%s/working/url.html' % path
                  if os.path.exists(urlFrom):
                       mvURL = 'mv %s %s' % (urlFrom,urlTo)
                       print 'Moving '+mvURL
                       os.system(mvURL)
    
                  bibFrom = '%s/bib.html' % path
                  bibTo   = '%s/working/bib.html' % path
                  if os.path.exists(bibFrom):
                       mvURL = 'mv %s %s' % (bibFrom,bibTo)
                       print 'Moving '+mvURL
                       os.system(mvURL)
    
                  if ('robot' in open(path+'/working/results.html').read() and (not  'robotic' in open(path+'/working/results.html').read())): # somebody had research about robotic something! fixed with and
                      removeFile = 'rm %s' % nameFileCSV
                      os.system(removeFile) # Remove the empty file that was created above so it won't be confused with an actual conclusion that the person has no citations
                      jaccuseTime = str(time.strftime("%H:%M:%S"))
                      print jaccuseTime+': Google accused us of being a robot.'
                      #  os.system("open -a /Applications/Firefox.app "+path+"/working/results.html")
                      mins_to_wait_after_accusation = 2*mins_to_wait_after_accusation # Keep doubling the wait time until Google forgives or forgets us
                      print str("Increasing minutes to hide to "+str(mins_to_wait_after_accusation))
                      time.sleep(mins_to_wait_after_accusation*60)
                      removeFile = 'rm %s' % nameFileCSV
                      os.system(removeFile) # Remove the empty file so it won't be confused with an actual conclusion that the person has no citation
                      repeatUntilSuccess = 1 # Actually it's a failure but setting this to 1 makes the program move to the next person, which makes Google less suspicious than trying again to retrieve the same person
                  else:                      # Google did not accuse us of being a robot, so save all the results
                      nameFileCMD = open(path+'/%s.cmd' % nameFile,"w")
                      nameFileCMD.write(scholarMethCmd)
                      nameFileCMD.write("\n")
                      nameFileCMD.write(scholarOrigCmd)
                      nameFileCMD.close()
                      firstLocation = '\"'+path+'/working/results.html'+'\"'
                      secondLocation = '"'+path+'/'+nameFile+'.html'+'"' 
                      nameFileHTMLMake = 'cp  '+firstLocation+' '+secondLocation # results.html is created by scholar-Methods.py
                      firstLocation = '\"'+path+'/working/url.html'+'\"'
                      secondLocation = '"'+path+'/'+nameFile+'.url'+'"' 
                      nameFileURLMake  = 'cp  '+firstLocation+' '+secondLocation  # results.html is created by scholar-Methods.py
                      print(nameFileHTMLMake)
                      os.system(nameFileHTMLMake) # Move to results directory with author-name as filename
                      print(nameFileURLMake)                  
                      os.system(nameFileURLMake)  # Move to results directory with author-name as filename
                      print 
              else: # if os.path.isfile(path+"/working/results.html") failed
                  print 'No results were returned, likely indicating that the server did not connect.  Wait for a prespecified interval then try the next person.'
                  if os.path.isfile(nameFileCSV):
                      removeFile = 'rm %s' % nameFileCSV
                      os.system(removeFile) # Remove the empty file so it won't be confused with an actual conclusion that the person has no citations
                  print str("Waiting "+str(mins_to_wait_after_suspicion)+" minutes.")
                  writeSearchCommandToLog = 'echo '+argstring+' >> '+path+'/results/returned_no_results.log'
                  os.system(writeSearchCommandToLog)
                  time.sleep(mins_to_wait_after_suspicion*60)
                  repeatUntilSuccess = 1 # Actually it's a failure but setting this to 1 makes the program move to the next person, which makes Google less suspicious than trying again to retrieve the same person

      # End while (repeatUntilSuccess == 0) - so things beyond here will be executed only upon success
    # If nameFileCSV doesn't exist, that must be because no results were returned; the next line's if statement fails, and we fall through to the end of the for names loop, so processing of the next name starts
    googleSearchCV=''
    if os.path.isfile(nameFileCSV): # Read this persons data in again, in case it is a person whose scholar readin was skipped because their data already existed
          resultsCSV = os.stat(nameFileCSV)
          if resultsCSV.st_size == 0:
              nameFileCitesMake = 'echo 0 > %s' % nameFileCites
              print str("The file "+nameFileCSV+" is empty, presumably indicating the search failed to find any citations for this person.")
              os.system(nameFileCitesMake)
              nameFileURLByAuthor = path+'/%s.url' % (nameFile) # Retrieve the url that generated this author's results
#              nameFileURLByAuthorHYPERLINK = '=HYPERLINK(CONCATENATE("file:/%s/results/ByName/%s.html"),"%s.html")' % (path,nameSort,nameSort)
              with open(nameFileURLByAuthor,'r') as urlFile:
                  url=urlFile.read().replace('\n', "")  # Import the url 
              nameFileURLByAuthorHYPERLINK = "%s" % url # % (path,nameSort,nameSort)
#              nameFileURLByAuthorHYPERLINK = '=HYPERLINK(CONCATENATE("file:/%s/results/ByName/%s.html"),"%s.html")' % (path,nameSort,nameSort)
              if os.path.isfile(nameFileURLByAuthor): # This should exist because we'd only have gotten here if nameFileCSV exists
                      urlFile     = open(nameFileURLByAuthor)
                      urlFromFile = urlFile.read()
                      urlFromFileHYPERLINK = '%s' % urlFromFile
#                      urlFromFileHYPERLINK = '=HYPERLINK("%s","%s.url")' % (urlFromFile,nameSort)
              else: 
                      print 'For some reason the url file for %s does not exist' % nameFile
                      print 'Setting the url to blank.'
                      urlFromFileHYPERLINK = ''
              noneFound = "0"
#              authinfoNewRow = [nameOrig, noneFound, nameFileURLByAuthorHYPERLINK, urlFromFileHYPERLINK, urlScholar, googleSearchCV]
              authinfoNewRow = [nameOrig, noneFound, urlFromFileHYPERLINK, urlScholar, googleSearchCV]
              #---------------- The following segment deletes the current author from the csv before writing the new data for the author --------------------# 
              with open(path+"/working/authinfo.csv", "rU") as authinfoFileOne:          #open the current list of authors
                  authinfoFileOne = csv.reader(authinfoFileOne)                          #assign an iterable from the current list of authors
                  with open(path+"/working/authinfo_temp.csv", "wb") as authinfoFileTwo: #create a new file to write to
                      authinfodel= csv.writer(authinfoFileTwo,quotechar = '"',quoting=csv.QUOTE_ALL)                           #assign the writer object
                      for line in authinfoFileOne:                                       #loop over each line of the authors name and cites file
                          if nameOrig not in line:                                       # if the current author's name is NOT in a row
                              authinfodel.writerow(line)                                 #then write that row 
                      authinfoFileTwo.close()                                            #close the write file without writing the current author's old data
              os.remove(path+"/working/authinfo.csv")        
              os.rename(path+"/working/authinfo_temp.csv",path+"/working/authinfo.csv") #rename the temp file to be the new master author list
              #---------------------------------------------------------------------------------------------------------------------------------------------#
              with open(path+"/working/authinfo.csv", "a") as authinfoFile:
                      authinfo = csv.writer(authinfoFile,quotechar = '"',quoting=csv.QUOTE_ALL)
                      authinfo.writerow(authinfoNewRow)
                      authinfoFile.close()
              tempNames  = pandas.DataFrame.from_csv(path+'/working/auth_names_update.csv',header=0, index_col=False)
              tempGSInfo = pandas.DataFrame.from_csv(path+'/working/authinfo.csv'         ,header=0, index_col=False)
              mergedNames = pandas.DataFrame.merge(tempNames, tempGSInfo, left_on='nameid',right_on='nameOrig', how='right')
              mergedNames.to_csv(path+'/working/authinfo_complete.csv', index=False)
          else: # A nonzero CSV file exists, so process it
              cites = 0
              tempdata = csv.reader(open(nameFileCSV), delimiter=",") #open the data from google scholar
              tempdata.next() #skip first line (header)

              for row in tempdata:
                  if row[citesCol].isdigit(): # Sometimes the csv file has junk lines that are strings; skip them
                      cites = cites+int(row[citesCol]) # Citations to this paper
                      row.append(nameSort)  #add author's sort name
                      row.append(nameFull)  #add author's full name
                      row.append(name_Last) #add author's last name
                      row.append(name_Frst) #add author's first name
                      row.append(name_Midl) #add author's middle name
                      bibinfo.writerow(row)
              citesStr = str(cites)
              nameFileCitesMake = 'echo '+citesStr+' > %s.cites' % nameFile
              os.system(nameFileCitesMake)
              nameFileURLByAuthor = path+'/%s.url' % (nameFile)
              with open(nameFileURLByAuthor,'r') as urlFile:
                  url=urlFile.read().replace('\n', "")
              nameFileURLByAuthorHYPERLINK = '=HYPERLINK("%s","Search-%s.url")' % (url,name_Last) # % (path,nameSort,nameSort)
#              nameFileURLByAuthorHYPERLINK = "%s" % url # % (path,nameSort,nameSort)
#              nameFileURLByAuthorHYPERLINK = '=HYPERLINK(CONCATENATE("file:///%s/results/ByName/%s.html"),"%s.html")' % (path,nameSort,nameSort)
              if os.path.isfile(nameFileURLByAuthor): # This should exist because we'd only have gotten here if nameFileCSV exists
                  urlFile     = open(nameFileURLByAuthor)
                  urlFromFile = urlFile.read()
#                  urlFromFileHYPERLINK = '=HYPERLINK("%s","%s.url")' % (urlFromFile,nameSort)
                  urlFromFileHYPERLINK = '%s' % urlFromFile
                  googleSearchUrl = 'https://www.google.com/?q='
                  nameFullPlus = str(nameFull)
                  nameFullPlus = nameFullPlus.replace(" ","+")
                  googleSearchCV = '=HYPERLINK("%s%s+CV","CV-Search")' % (googleSearchUrl,nameFullPlus)
                  if pandas.isnull(authorNameFix) != True :
                      authorNameFix = str(authorNameFix)
                      authorNameFix = authorNameFix.replace(",","")
                      authorNameFix = authorNameFix.replace(" ","+")
                      googleSearchCV = '=HYPERLINK("%s%s+CV","CV-Search")' % (googleSearchUrl,authorNameFix) 
              else:
                  print 'For some reason the url file for %s does not exist' % nameFile
                  print 'Setting the url to blank.'
                  urlFromFileHYPERLINK = ''
              authinfoNewRow = [nameOrig, citesStr, urlFromFileHYPERLINK, urlScholar,googleSearchCV] #assign the data to be written
              #---------------- The following segment deletes the current author from the csv before writing the new data for the author --------------------#
              with open(path+"/working/authinfo.csv", "rU") as authinfoFileOne: #open the current list of authors
                  authinfoFileOne = csv.reader(authinfoFileOne) #assign an iterable from the current list of authors
                  with open(path+"/working/authinfo_temp.csv", "wb") as authinfoFileTwo: #create a new file to write to
                      authinfodel= csv.writer(authinfoFileTwo,quotechar = '"',quoting=csv.QUOTE_ALL) #assign the writer object
                      for line in authinfoFileOne: #loop over each line of the authors name and cites file
                          if nameOrig not in line:  # if the current author's name is NOT in a row
                              authinfodel.writerow(line) #then write that row 
                      authinfoFileTwo.close() #close the write file without writing the current author's old data
              os.remove(path+"/working/authinfo.csv")
              os.rename(path+"/working/authinfo_temp.csv",path+"/working/authinfo.csv") #rename the temp file to be the new master author list
              #---------------------------------------------------------------------------------------------------------------------------------------------#
              with open(path+"/working/authinfo.csv", "a") as authinfoFile: 
                  authinfo = csv.writer(authinfoFile,quotechar = '"',quoting=csv.QUOTE_ALL)
                  authinfo.writerow(authinfoNewRow) #write the current author's data as a new row to the output spreadsheet
                  authinfoFile.close()

              #merge phd info from auth_names_update, and merge institution info from auth_inst 
              
              tempNames  = pandas.read_csv(path+'/working/auth_names_update.csv',header=0, index_col=False)
              tempGSInfo = pandas.read_csv(path+'/working/authinfo.csv'        , header=0, index_col=False)

              mergedNames = pandas.DataFrame.merge(tempNames, tempGSInfo, left_on='nameid',right_on='nameOrig', how='right')
              mergedNames.to_csv(path+'/working/authinfo_complete.csv', index=False)

          if skipped == 0 and (names.index(name) != len(names)-1): # If this is a person for whom we have done a new search, then wait (unless this is the last person); otherwise, instantly plow ahead
              sleepMins = mins_between_searches*random.randrange(1,4) #pick random number of minutes between 1 and 4 (allows for randomly waiting longer if Google gets suspicious)
              print str('Sleeping '+str(sleepMins)+' minutes after successful fetch to avoid Google robot detection')
              time.sleep(60*sleepMins) # Seconds to sleep
    if newModList == 1:
        changeAuthRowNumber = np.where(changeData['nameid']==nameOrig)[0] 
        changeData.ix[changeAuthRowNumber,'newMod'] = 0 #set this variable to zero to indicate that the new info related to the authors was processed
        changeData.to_csv(path+'/inputs/auth_changes.csv',index=False)
        print 'NOTE: the newMod variable in the auth_changes.csv file was reset for : ' +str(nameOrig)
        
#get the author institution from the auth_inst.csv file and merge it into authinfo_complete
authInst    = pandas.read_csv(path+'/working/auth_inst.csv', header=0, index_col=False)
finalData   = pandas.read_csv(path+'/working/authinfo_complete.csv',index_col=False)
finalData   = finalData.drop('authorsorganization',1)
mergedNames = pandas.DataFrame.merge(authInst,finalData, left_on='nameid', right_on='nameOrig', how='right')

#add in any other info we have on new authors
newAuthorInfo = pandas.read_csv(path+'/inputs/newauthinfo.csv', header=0, index_col=False)
mergedNames   = pandas.DataFrame.merge(newAuthorInfo, mergedNames, left_on='nameid', right_on='nameOrig', how='right')
varnames = ['authorsorganization','phdyearid','phdinstitutionid', 'titleid', 'email']

for var in varnames:
    varadd = '%s_add' % var
    mergedNames[var] = np.where(pandas.isnull(mergedNames[varadd]), mergedNames[var],mergedNames[varadd])
    mergedNames = mergedNames.drop(varadd,1)

mergedNames['nameid'] = mergedNames['nameid_y']
mergedNames = mergedNames.drop('nameid_x',1)
mergedNames = mergedNames.drop('nameid_y',1)
    
mergedNames.to_csv(path+'/working/authinfo_complete.csv', index=False)

cols = ['nameid','phdyearid','authorsorganization','phdinstitutionid','cites_of_top_papers','urlScholar','urlFromFileHYPERLINK','googleSearchCV']
mergedNamesToShare = mergedNames[cols]
mergedNamesToShare = mergedNamesToShare.sort_values(by=['phdyearid','cites_of_top_papers'],ascending=[1,1])

#create cp  of output file that can be opened manually
mergedNamesToShare.to_csv(path+'/results/Global/authinfo_ToShare.csv', index=False)

bibinfoFile.close()

if os.path.isfile(path+"/url.html"):
    os.system('rm  '+path+'/url.html') #remove old url file 
if os.path.isfile(path+"/results.html"):
    os.system('rm  '+path+'/results.html') # remove old result file

if os.path.isfile(path+"/results.html"):
    os.system('rm  '+path+'/results.html') # remove old result file
