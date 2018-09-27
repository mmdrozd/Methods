# Reading and Debugging Bash Scripts

The purpose of structuring your Dropbox folders as described in `Create-Your-Directories-For-Sharing_And-Share-Assignments-Folder-With-Instructor` is not mainly to make it easier to collect and organize your assignments. It is to provide a practical example of how to incorporate bash scripts in your workflow.

This assignment asks you to try to figure out how the workflow works, by examining those scripts. You will be able to answer the questions below by performing Google searches


0. In emacs, open the script `Assignment-Copy-To-Personal-Dropbox-Paths.sh`
   * Explain what the first `if .. fi` block does

0. In emacs copy the part of the line beginning `moniker=` that follows the #

0. Open a shell in emacs and paste that text into the shell

0. Use the 'echo' command to verify that you have correctly set the `shell variables` `assnDir` and `moniker`
   * This illustrates the point that you can copy text from the shell script and paste it into the shell, and it will work -- so long as any variables the script is using when it gets run, have been defined as shell variables.
   
0. Describe what the `for` loop does
   0. Inside the `for` loop, what does the sequence of setting `cmd=` something, then `echo`, then `eval` do?
      * Hint: If we weren't debugging/learning, the text that `cmd` is set equal to, would simply be directly in the script.

0. What is the purpose of the next for loop?

0. What does the `for f in *` accomplish?  In that for loop:
   * What does the `filenameNew+='_'$moniker` command do?
   
   
0. Now open the `Assignment-Gather_By-Assignment_By-Student.sh` script
   * What does the line beginning `scriptRoot=` do?
   * What is the purpose of the mkdir command here?
   * Explain what the "-Rf" and "a+w" mean in the chmod command
   * What does the "-r" do in the cp command?
   * Why is there a `*` in the source but not the destination of the cp command?
   * What does the `[ ! -d $dir1 ]` line test for?
   * What does `[ ! -z "$(ls -A $f)" ]` test for?
