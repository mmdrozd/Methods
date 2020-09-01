Currently (2020-01-28) this creates the default VMs for Econ-ARK: 

Run `make.sh` and it will update files both here and in econ-ark/econ-ark-tools
Run `make_modified-for-econ-ark-by-size.sh MIN` or `MAX`:
	- MIN has the minimal amount of stuff needed to run econ-ark
	- MAX has Anaconda3, LaTeX, and other useful things

The script will create, in `~/GitHub/econ-ark/econ-ark-tools/Virtual/Machine/VirtualBox/ISO-maker/` 
scripts called `start.sh` and `finish.sh` and `create-unattended-iso_Econ-ARK-by-size.sh`

When the latter is called, it will create the corresponding ISO files on 

/media/sf_VirtualBox/[MIN|MAX]

which should be shared automatically with 

/Users/Shared/VirtualBox

Then, e.g., the XUBUNTARK-MIN-Builder should have the /MIN/[iso] attached to the CD-ROM drive
When that has been done, clone it to XUBUNTARK-MIN-Built, and then boot; everything should 
be automatically installed.

