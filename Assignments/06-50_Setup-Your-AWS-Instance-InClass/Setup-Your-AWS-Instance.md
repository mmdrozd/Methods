# Go through the steps necessary to create a remote instance of Ubuntu

https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#instances:sort=instanceID

0. Launch it

At shell:
   sudo apt -y update 

0. Connect to it

	mkdir GitHub
	cd GitHub
	git clone https://github.com/ccarrollATjhuecon/Methods.git
	cd ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Software
	./emacs-AWS.sh
	cd ~/GitHub/ccarrollATjhuecon/Methods/Tools/Install/Languages
	./Anaconda3-Latest.sh

0. Install the `REMARK` repo
	cd ~/GitHub
	git clone https://github.com/econ-ark/REMARK
	cd ~/GitHub/REMARK/REMARKs/SolvingMicroDSOPs

0. Execute the SolvingMicroDSOPs `do_all.py` command to show that it is all working
