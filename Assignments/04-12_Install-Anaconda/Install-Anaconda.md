
This assignment is to write a script that installs the Anaconda superset of the python programming language (the Anaconda `stack`)

0. Your script should be based on the instructions you can find by Googling "digital ocean install anaconda on Ubuntu." For this assignment you need only to use the part of the document before the heading _Setting Up Anaconda Environments_
   * You can ignore the `Prerequisites` heading -- we already have all the prerequisites on our class VMs
   * You should get the latest version of Anaconda3 for Linux -- it will have a name like `Anaconda3-x.x.x-Linux-x86_64.sh` where x.x.x is the version number
   * When asked where to install it, you should accept the default /home/methods/anaconda3
   * When asked 'Do you wish the installer to prepend the anaconda3 install location to PATH in your ~/.bashrc ? [yes|no]' you should answer 'no'
     * It is best to avoid editing your ~/.bashrc file whenever possible
	 * Ability to avoid editing ~/.bashrc is facilitated by the fact that the ~/.bashrc file reads in the ~/.bash\_aliases file, which is where customizations can go
	 * The custom ~/.bash_aliases file on your machine in turn reads in a Methods-class-specific dotbashrc-linux file
	 * That dotbashrc-linux file has the configuration info needed to tell the machine that Anaconda is in ~/anaconda3
   * If the installer asks you to install anything else, say NO
1. After anaconda is installed, you will need to reboot your virtual machine in order to make it fully accessible	 
1. Test whether you have succeeded by typing `which python` at the command line
   * The result should be a path like `/usr/local/anaconda3/bin/python`
1. Once Anaconda is installed, you should also install the jupyter notebook extensions:
   `conda install -c conda-forge jupyter_contrib_nbextensions`
   

