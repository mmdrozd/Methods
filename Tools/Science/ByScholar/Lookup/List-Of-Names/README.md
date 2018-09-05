The code herein constitutes a set of tools for systematically retrieving info about a scholar's research output using Google Scholar. It builds on the tool scholar.py from GitHub.

Problem:    Google doesn't like robots (and you are a robot if you are running this script!)
Diagnostic: If the script does not return a result for a long time, or if the debug html output indicates an error code of 503 or 504, this probably means Google suspects you of being a robot

Solution: No good ones exist. But:

0. You can gain a temporary reprieve by

* Copying the url that was sent to Google which resulted in the robot accusation into a browser;
* Responding to the Captcha or "I am not a robot" tickbox to prove you're not a robot;
* Use a browser extension (on Chrome, cookies.txt works; the key is that it exports in Netscape format) to export the cookies *after* you have proved yourself not to be a robot
    * Export the cookies to ./inputs/cookies.txt
	* Immediately after exporting the cookies, run the script again.  You should be able to do a few more searches before Google becomes totally convinced that you are a robot and blocks you again

0. If you wait a day or two, Google will forgive you and let you search again

Experience suggests that:

0. If you try to search from an anonymous session, Google immediately thinks you're a robot;
0. If you search with an empty cookies.txt file, that is better but not great;
0. If you search with a cookies.txt file exported from a session where you were logged into a Google account, you are given more of the benefit of the doubt;
0. Google is smart enough to eventually detect your robotic nature across different IP addresses (say, JHU VPN vs home), different accounts, different computers; but each of these
strategies has some efficacy in staving off the accusation

Usage:

Prepare to run:

./inputs/auth_names_update.csv : Put here a csv set of information for each scholar you are interested in, identified by the headers
./inputs/auth_inst.csv         : Put here information on the institution with which the author is currently associated


PS.  Another tool that looks promising is 

https://github.com/OrganicIrradiation/scholarly


