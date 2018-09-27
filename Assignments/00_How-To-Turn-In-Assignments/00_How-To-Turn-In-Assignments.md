
How To Turn In Assignments
--------------------------

The first thing you do after you `Get-A-Course-Dropbox-Account` is to create at the root of your dropbox folder your `/pri` and `/shr` and `/pub` folders as described in `/Methods/Advice/Organizing-Sharing-Of-Materials.md`

The next thing you should do is to make a directory inside your `shr` directory called `Methods/Assignments`:

	cd ~/Dropbox
	mkdir -p ./shr/Methods/Assignments # mkdir -p makes the full path to a directory
	mkdir -p ./pri/Methods/Assignments

When you are working on `[assignmentName]` from the public GitHub `/Methods/Assignments` folder, you will do the work on the assignment in the corresponding directory you will have created on your VM at `[droot]/pri/Methods/Assignments/[assignmentName]`.  
   * `[droot]` is the Dropbox root, `~/Dropbox`; it will be understood to be present in all future references to `/pri`, `/shr`, and `/pub`; that is, when I write `/pri/Methods/Tools` the full pathname you will use is `~/Dropbox/pri/Methods/Tools`

As a concrete example, student `CarrollCD` working on assignment described in `00-97_Win-The-Nobel-Prize.md` would do all work for that assignment in his `/pri/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD/` folder.

Your first step in doing a new assignment should be to run a script I have devised to make sure that the files in your `/pri` directory are created with the right name and in the right place.  (See below for instructions for running the script).

When you have completed your work in your `/pri` version of the directory, and are ready to turn in the assignment, all you need to do is to copy your final solution from `/pri/Methods/Assignments/` to `/shr/Methods/Assignments/` using the unix `cp` (copy) command (the `-r` means to copy `recursively`):

    cd ~/Dropbox
    cp -r ./pri/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD/* ./shr/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD/

where the "./" at the beginning of a pathname indicates that what follows is the remainder of the path drilling down from the working directory (`~/Dropbox` in this case).

The script you need to run is in:

    /Methods/Tools/Scripts-For-Students

and its name is

	Assignment-Copy-To-Personal-Dropbox-Paths.sh

and an example of how to run it would be:

	cd /Methods/Tools/Scripts-For-Students
	./Assignment-Copy-To-Personal-Dropbox-Paths.sh 00_How-To-Turn-In-Assignments CarrollCD

It basically just creates the files and directory structure needed for the workflow above.

To make all of this work, you will need to login to your Dropbox account, and "Share" with `instructor.methods.dropbox@llorracc.org` the `Assignments` folder you created above.  (See [Instructor-Procedure](#Instructor-Procedure)  below for details); sharing your Assignments folder in this way gives the instrucor account access to  everything inside of your `Assignments` folder.  Dropbox will automatically send `instructor.methods.dropbox@llorracc.org` a message to let me know that the assignment has been posted; you do NOT need to re-share your `/shr/Methods/Assignments` folder ever again after the first time).

Warnings:

* If some assignment requires you to download software, you should _not_ save the `.zip` or the package itself (which may occupy hundreds of megabytes of space) in your `/shr` folder. If every student copied all these files, the instructor account would run out of space for all students' assignments!

* Any file you make by modifying an existing file should be at the same place in the file hierarchy as the original. This is so that when the instructor copies all assignments into a common locale (via a script), the original and all of the students' modified versions will be next to each other in a directory listing.

* Remember that for grading, all NEW files and folders you create will be copied into a common directory with the files of other students for that same assignment. If you name your file something like 'solution.sh' there will be no way to tell WHOSE solution it is. There are two options to overcome this problem:
	   0. End the files you create with your moniker, e.g. 'solution_CarrollCD.sh'
	   0. Put all the files you create into a subsubdirectory, e.g. 'CarrollCD/solution.sh'. That is, your files would be at `/shr/Methods/Assignments/00-97_Win-The-Nobel-Prize/CarrollCD`

# Instructor-Procedure
Upon receiving the students' shared assignment folders the first time, the instructor will rename the folder the student sent (which was named `Assignments`) to the student's `[Moniker]` and put the result in a private Dropbox folder `[droot]/Assignments-Turned-In/Latest/ByStudent/[Moniker]`.  At any point thereafter, the instructor can run scripts in `/Methods/Assignments/00_How-To-Turn-In-Assignments_` to put all students' solutions to a given assignment in the directory `[droot]/Assignments-Turned-In/ByAssignment/` so students solutions to the assignments can be easily compared.
