
The directory of screenshots at 

    `/Methods/Tools/Install/Machines/020_Installing-Ubuntu-On-VirutalBox_Illustrated/Screenshots`

uses conventions roughly defined in the file 

    `/Methods/Tools/Install/Markdown-Conventions-For-Filenames.md`

Your task is to use Emacs to write a bash script that converts that (admittedly ugly) file structure into a Markdown document which will be much easier to read. 

I expect that you will need to rely extensively on Google searches to help you figure out the right syntax to use to accomplish your goals. Part of what you are supposed to learn in performing this exercise is precisely the fact that the most efficient way to get things done is not necessarily to study the language comprehensively until you can deduce exactly the right command from your textbook knowledge. Instead, you can cobble together something that works by making a mashup of results you get when you do searches like "How do I loop over files in a directory in the bash shell?"


Your results should obey the following rules:

0. The date and time information preceding the text of a folder name should be replaced by a numbered list.  For example, `Screen Shot 2017-02-17 at 17.25.48_Welcome-To-VirtualBox` would begin as item 1 in the compiled Markdown document.  (Hint: note the adjective _compiled_. Remember that in raw Markdown a list in which every item begins with "0." is compiled into an ordered list)

0. The text separators between words like `-` should be replaced with appropriate punctuation per the guidelines 

0. Bonus points if your code descends into subdirectories and includes those results as indented Markdown

0. You may find it somewhat difficult to deal with quote marks and other punctuation symbols, because those characters often have some special meaning to them in the bash language. If you want to make progress on other aspects of the problem while leaving aside the punctuation parts, you could start by replacing, say, -_ and _- not with double quote marks but with something easy like QQ. Then you can come back to figuring out how to produce quote marks later.

0. You will likely need to use some special tools for manipulating text that are actually standalone programs and not technically part of the bash shell.  (They can be used identically in other shells, or from programs that are not shells). The main such tools likely to be useful to you are are `awk` and `sed`.

0. The `-n` flag in the `echo` command may be useful to you; the unflagged version of `echo` puts a newline at the end of its output, but with the `-n` flag the output is just left hanging (and that means that the next `echo -n` command will add to the string you started to build with your first `echo -n` command).

