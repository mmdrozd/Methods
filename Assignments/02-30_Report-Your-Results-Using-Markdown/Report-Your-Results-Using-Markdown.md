
This assignment asks you to use emacs and Markdown to give feedback on this week's assignments

   * Because I fiddle with the numbers that prefix the name of files, when you see `[Num]` below that is a standin for whatever the actual numerical prefix is for the file in question. So, for example, I would refer to this file as `[Num]_Report-Your-Results-Using-Markdown.md`

0. Launch a `Terminal` window

0. Copy the text of this week's assignments (including this file!) from the class GitHub folder to the corresponding location in your /pri directory structure

   0. In a terminal in your VirtualBox Xubuntu machine, if it is configured correctly, you should be able to find the assignment Markdown files by three different routes, e.g.:

      * `/Methods/Assignments/[Num]_Report-Your-Results-Using-Markdown.md`

      * `~/Dropbox/Methods/Assignments/[Num]_Report-Your-Results-Using-Markdown.md`

      * `/home/methods/Dropbox/Methods/Assignments/[Num]_Report-Your-Results-Using-Markdown.md`

   0. In the terminal shell, change your location to point to any of these directories via the command `cd [one-of-those-directory-paths]`

   0. Now make your own private copy of each of the files by typing `cp [Num]_* [droot]/pri/Methods/Assignments` where `[droot]` is a standin for your dropbox root (~/Dropbox)

   0. Change to your private directory: `cd /pri/Methods/Assignments` (I've omitted the `[droot]` here and hencefoth)

0. Now, you will edit each of the three assignment files to add comments and feedback (you may need to first change the permissions of the files to be able to edit them, you can do this by typing `chmod u+w 02*` in the Terminal; also recall how to open a file to work in emacs)

0. All lines you add to the files should end with your initials (FirstMiddleLast, [FML])

0. For example, if this were a line I had added, it would end with [CDC]

0. For each line in the assignment that asks you to do something, you should make one of three responses

   0. If you executed the step with no difficulty and the instructions were easy to follow, you can just write Done [FML].  The next line provides an example, if I were a student, of how I would respond to the current line if I had finished going through all the assignments and had done everything:

      0. Done [CDC]

   0. If the instructions were clear enough (in retrospect) but they were difficult to execute in practice, you might provide a response like

      0. Done (but hard) [CDC]

   0. If the instructions were not clear enough for you to be able to figure out what to do and you were unable to accomplish it, you should provide a description of what you tried and your guess of why it failed

      0. I couldn't change the names of the files to add my moniker, and I couldn't edit them after I copied them to my `[droot]/pri/Methods/Assignments` directory  [CDC]

   0. If you think the instructions should be improved or added to or clarified, you could provide proposed edits. For example, you might want to edit the line earlier in the this assignment that reads:

       0. Now make your own private copy of each of the files by typing `cp [Num]_* [droot]/pri/Methods/Assignments` where `[droot]` is a standin for your dropbox root (~/Dropbox)

       0. Now make your own private copy of each of the files by typing `cp [Num]_* [droot]/pri/Methods/Assignments` where `[droot]` is a standin for your dropbox root (~/Dropbox) and [Num]_* stands for 02-30 for this document

   0. When you are done editing the assignments, you should be able to examine the resulting prettified Markdown document by hitting C-c C-c p (that is, Control-C, Control-C, p). You may want to search about this command online. (Google: `markdown editing mode in emacs`)
