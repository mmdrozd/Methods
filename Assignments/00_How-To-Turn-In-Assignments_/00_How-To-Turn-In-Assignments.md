
How To Turn In Assignments
--------------------------

The first thing you do after you `Get-A-Course-Dropbox-Account` is to create at the root of your dropbox folder your `/pri` and `/shr` and `/pub` folders as described in `/Methods/Advice/Organizing-Private-vs-Shared-vs-Public-Materials.md`

The next thing you should do is to make a directory inside your `shr` directory called `Methods/Assignments`:

	cd ~/Dropbox
	mkdir -p ./Methods/Assignments

When you are working on `[assignmentName]` located from the `/Methods/Assignments` folder, you will do your work in a directory you will have created on your VM at `[droot]/pri/Methods/Assignments/[assignmentName]_[Moniker]`.  (`[droot]` is the Dropbox root, `~/Dropbox`; it will be understood to be present in all future references to `/pri`, `/shr`, and `/pub`; that is, when I write `/pri/Methods/Tools` the full pathname you will use is `~/Dropbox/pri/Methods/Tools` or equivalently
`/home/methods/Dropbox/pri/Methods/Tools` since if you are logged in as the user named methods, so `~` is a shortcut for `/home/methods`).

As a concrete example, student `CarrollCD` working on assignment described in `00-97_Win-The-Nobel-Prize.md` would do all work for that assignment in his `/pri/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD/` folder. 

I have provided a script that you should run to make sure that the files in your `/pri` directory are created with the right name and in the right place. When you have completed your work in your `/pri` version of the directory, and are ready to turn in the assignment, all you need to do is to copy your final solution from `/pri/Methods/Assignments/` to `/shr/Methods/Assignments/` using the unix `cp` (copy) command (the `-r` means to copy `recursively`):

    cd ~/Dropbox
    cp -r ./pri/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD/ ./shr/Methods/Assignments/00-97_Win-The-Nobel-Prize_CarrollCD

where the "./" at the beginning of a pathname indicates that what follows is the remainder of the path drilling down from the working directory (`~/Dropbox` in this case).

To make all of this work, you will need to login to your Dropbox account, and "Share" your `Assignments` folder with `instructor.methods.dropbox@llorracc.org` (note the `/shr` in that pathname).  (See [Instructor-Procedure](#Instructor-Procedure)  below for details); sharing your Assignments folder in this way gives the instrucor account access to  everything inside of your `Assignments` folder.  Dropbox will automatically send `instructor.methods.dropbox@llorracc.org` a message to let me know that the assignment has been posted; you do NOT need to re-share your `/shr/Methods/Assignments` folder ever again after the first time).

* Warning: If some assignment requires you to download software, you should _not_ save the `.zip` or the package itself (which may occupy hundreds of megabytes of space) in your `/shr` folder. If every student copied all these files, the instructor account would run out of space for all students' assignments!

* Warning: Any file you make by modifying an existing file should be at the same place in the file hierarchy as the original. This is so that when the instructor copies all assignments into a common locale (via a script), the original and all of the students' modified versions will be next to each other in a directory listing.

* Warning: Remember that for grading, all files and folders you create will be copied into a common directory with the files of other students for that same assignment. If you name your file something like 'solution.sh' there will be no way to tell WHOSE solution it is. There are two options to overcome this problem:
	   0. End the files you create with your moniker, e.g. 'solution_CarrollCD.sh'
	   0. Put all the files you create into a subsubdirectory, e.g. 'CarrollCD/solution.sh'. That is, your files would be at `/shr/Methods/Assignments/00-97_Win-The-Nobel-Prize/CarrollCD`

# Instructor-Procedure
Upon receiving the students' shared assignment folders the first time, the instructor will rename the folder the student sent (which was named `Assignments`) to the student's `[Moniker]` and put the result in a private Dropbox folder `[droot]/Assignments-Turned-In/Latest/ByStudent/[Moniker]`.  At any point thereafter, the instructor can run scripts in `/Methods/Assignments/00_How-To-Turn-In-Assignments_` to put all students' solutions to a given assignment in the directory `[droot]/Assignments-Turned-In/ByAssignment/` so students solutions to the assignments can be easily compared.
