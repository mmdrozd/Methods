
This assignment is to write a script set up the HARK toolkit within an appropriate Anaconda environment. 

0. Set up a `conda` environment in which to run HARK
    * Do a Google search to find a tutorial on `conda environments`
	* Using what you have learned, write a bash script to create an environment named `ARK` (if such an environment does not already exist)
	* The environment should specify that it uses python 3, not python 3
0. Install econ-ark via `pip install econ-ark` (or, if you have already installed it, `pip install --upgrade econ-ark`
0. In your `~/Dropbox/GitHub` directory, git clone:
   * `econ-ark/DemARK`
   * `econ-ark/REMARK`
0. In the shell, navigate to the `REMARK/REMARKs/SolvingMicroDSOPs` directory and from inside that directory
    * Activate the ARK environment that you have created:
	   `source activate ARK`
	* Launch the `spyder` python development environment (just type `spyder &` at the command prompt)
	* Load the `do_all.py` file and run it
	   * Hint: Is there something that looks like a `play` button? Bingo!
0. Navigate to the `DemARK/notebooks` directory and from inside that directory
    * Activate the ARK environment that you have created:
	   `source activate ARK`
	* Launch the `jupyter notebook` tool
	* Open the `Gentle-Intro-To-HARK-PerfForesightCRRA` notebook and execute it
