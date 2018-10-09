	1. For students who have not previously forked the repo: Fork it on GitHub.com

    mkdir ~/GitHub/Forks
	cd !$
	git clone git@github.com:[STUDENT-GITHUB-HANDLE]/Methods.git

   1. For students who _have_ previously forked the repo
      * Move the local copy of the fork into ~/GitHub/Forks
	  * `cd ~/GitHub/Forks/Methods`

   1. For both groups of students: (Google "keeping a git fork up to date" gist CristinaSolana")
	  * git fetch upstream
      * git remote add upstream git://github.com/[STUDENT-GITHUB-HANDLE]/Methods.git
	  * git pull upstream master
	
   1.  In your fork, go to Students/2018-Fall/Monikers
      * Create a file named [Moniker].md
      * git config --global user.email "your email on GitHub"
      * git config --global user.name "your name on GitHub"
      * Put your real name in the markdown file
      * `git add .`
      * `git commit -m 'Reveal who [Moniker] is'`
	  * git push

   1. Make a pull request (help.github.com/articles/creating-a-pull-request-from-a-fork)
      1. Go to the forked repo ([STUDENT-GITHUB-HANDLE]/Methods)
	  1. Right of the branch menu, "New pull request"
	  1. Compare across forks
	     * base fork: ccarrollATjhuecon/Methods
		 * base: master
		 * head fork: [STUDENT-GITHUB-HANDLE]/Methods
		 * head: master (or your branch name you want to create pull request for)
		 * click: Create pull request

