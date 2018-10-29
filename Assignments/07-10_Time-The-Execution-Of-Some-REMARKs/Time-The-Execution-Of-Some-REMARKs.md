
0. Pull the latest versions of the REMARK repo
0. For both the SolvingMicroDSOPs and the cAndCwithStickyE repos,
    * Verify that you are able to execute the "do_all.py" programs in spyder on your VM
    * Modify the do_all.py file to `do_all_Moniker.py` so that
      1. When run, it executes the _min and _mid versions of the code
      1. It calculates the time required for running those two versions
      1. It creates a do_all_Moniker.out file that reports the exact specs of of your VM setup (like, which version of Linux, what version of VirtualBox, what OS you are using (not just "Windows" or "MacOS" but the exact version), what kind of hardware you are running it on (the exact model of your laptop, its RAM, etc).  Basically, enough information that you are confident that if somebody else took that information and ran the code themselves, they would get a very similar result.
0. When you have finished doing this on your VM, repeat the exercise on an AWS EC2 instance
   * You will probably want to review the sketchy instructions `Get-AWS-Account-And-Learn-About-EC2.md` and the info in
   `/Methods/Tools/Install/Machines/030_Amazon-Web-Services_Elastic-Cloud/Scripts`
