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
      * Put your real name in the markdown file
      * `git add .`
      * `git commit -m 'Reveal who [Moniker] is'`
	  * git push

   1. Make a pull request (help.github.com/articles/creating-a-pull-request-from-a-fork)
      1. Go to the original repo (ccarrollATjhuecon/Methods)
	  1. Right of the branch menu, "New pull request"
	  1. Compare across forks
	     * base fork: ccarrollATjhuecon/Methods
		 * head fork: [STUDENT-GITHUB-HANDLE] 
		 * click: Create pull request

