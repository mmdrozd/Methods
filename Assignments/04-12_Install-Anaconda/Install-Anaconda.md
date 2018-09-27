
This assignment is to write a script that installs the Anaconda superset of the python programming language (the Anaconda `stack`)

0. Your script should be based on the instructions [here](https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-16-04). For this assignment you need only to use the part of the document before the heading _Setting Up Anaconda Environments_
   * You can ignore the `Prerequisites` heading -- we already have all the prerequisites on our class VMs
   * You should get the latest version of Anaconda3 for Linux -- it will have a name like `Anaconda3-x.x.x-Linux-x86_64.sh` where x.x.x is the version number
   * When asked where to install it, you should accept the default /home/methods/anaconda3
   * When asked 'Do you wish the installer to prepend the anaconda3 install location to PATH in your ~/.bashrc ? [yes|no]' you should answer 'no'
     * It is best to avoid editing your ~/.bashrc file whenever possible
	 * Ability to avoid editing ~/.bashrc is facilitated by the fact that the ~/.bashrc file reads in the ~/.bash\_aliases file, which is where customizations can go
	 * The custom ~/.bash_aliases file on your machine in turn reads in a methods-class-specific dotbashrc-linux file
	 * That dotbashrc-linux file has the configuration info needed to tell the machine that Anaconda is in ~/Dropbox/anaconda3


