
Your homework in this assignment is just to make a modified version of this markdown document with your feedback on the ease or difficulty of the steps, and on bugs encountered.  As usual, put the resulting document in your `/shr/Methods/Assignments` folder with the name `05-10_Install-TeXLive_[Moniker].md`.

0. Read through the script `/Methods/Tools/Install/Software/TeXLive.sh` which installs `TeXLive` and try to understand what it is doing (you should also go to any urls referenced in the script to learn what they have to say.  I have tried to document full what the script is doing.

    * WARNING: This installs the full version of TeXLive, which is I think about 3 gb.  To do so it downloads an installer that is also about 3gb.  Thus, if the amount of space occupied by your vdi file cannot expand by AT THE VERY LEAST 6gb (and to be safe, you should probably make it 10gb), you may need to consider another option, like (a) mounting an external drive (say, a spare USB key); and (b) rewriting the /TeXLive.sh script to download the installer to your external drive, and install from there, which at least saves you the disk space required for the installation files themselves.

0. Install the `okular` PDF viewer (`sudo apt -y install okular`)

0. Verify whether the `tlmgr` application is already installed; if not, install it so that you are able to install new LaTeX packages when you need them. 

   * As a test of this, install the `markdown` package that allows inclusion of markdown text within LaTeX. Be aware that the package may already be installed; if that is the case, the installer will create a second copy, and since TeXLive is huge you do NOT want it to do this.  If your old copy of TeXLive is not working as it should, you can uninstall it (Google to figure out how), then rerun the installer.

0. Most of my LaTeX cusomizations require LaTeX to have permissions to write to files outside of its own directory (at some point I intend to change that, but have not had time so far); change the default settings of the two key variables by adding these lines to the end of your `/usr/local/texlive/2016/texmf.cnf` file:

    `openout_any = a`

    `shell_escape = t`

    (You can find their default settings, along with the other defaults, in `/usr/local/texlive/2016/texmf-dist/web2c/texmf.cnf`)

    (You may need to change the permissions over the file)