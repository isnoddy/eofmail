{smcl}
{* *! version 1.2.1  8dec2016}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help eofmail"}{...}
{viewerjumpto "Syntax" "eofmail##syntax"}{...}
{viewerjumpto "Description" "eofmail##description"}{...}
{viewerjumpto "Options" "eofmail##options"}{...}
{viewerjumpto "Remarks" "eofmail##remarks"}{...}
{viewerjumpto "Examples" "eofmail##examples"}{...}
{title:Title}

{phang}
{bf:eofmail} {hline 2} Sends an email alert once a .do file has finished running successfully or unsuccessfully

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:eofmail}
{it:filename}{cmd: to(email_address) [,}{it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt to(email_address)}}Recipient email{p_end}
{synopt:{opt dof:older(do_folder)}}location of the .do file to be run; by default the current working directory is used.{p_end}
{synopt:{opt logf:older(log_folder)}}folder storing the .log file, .ps1 file and .text files; by default the current working directory is used.{p_end}
{synopt:{opt logn:ame(filename)}}name of the logfile created during processing; by default, file will be called "eoflog"{p_end}
{synopt:{opt a:tt}}attaches the logfile to the email{p_end}
{synopt:{opt cr:ed}}asks user to provide credentials for email{p_end}
{synopt:{opt smtpp:ort(smtp port)}}smtp port; default 587 {p_end}
{synopt:{opt smtps:server(smtp server)}}smtp server address; default smtp.gmail.com{p_end}
{synopt:{opt fr:om(name)}}name of sender; default is email username {p_end}
{synopt:{opt uf:ile(username file)}}location and name of .txt file containg users email address in plain text {p_end}
{synopt:{opt pf:ile(password file)}}location and name of .txt file containing users email password stored as a secure string{p_end}
{synopt:{opt cc(cc_recipient)}}email address of person cc'd on email{p_end}
{synopt:{opt nossl}}turns off ssl; by default ssl encryption is used{p_end}
{synopt:{opt ndel}}prevents deletion of username and password .txt files on completion{p_end}
{synopt:{opt t:est(email_address)}}sends a test before running the .do file{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:eofmail} sends an email message on the successful or unsuccessful completion of a .do file. A .do file
is given as an input to the program and runs normally, with the exception that error messages 
coming from the .do file are captured. Upon successful completion of the .do file an email saying:
"You nailed it! Your program ran successfully without error" will be sent. The subject heading will be the
name of the input .do file and an attachment will be included if specified. If the .do files exits with error
an email will be sent that includes the error message and the message "Unfortunately things didn't go as planned. 
But that's OK. It will be better next time. Here is the error message:".

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}				
{opt to(email_address)} is the email recipient. Note that the recipient and sender cannot have the same
email address.

{phang}				
{opt dofolder(do_folder)} is the folder storing the .do file to be run in stata. 

{phang}				
{opt logfolder(log_folder)} is the folder used to store the .log file, the .ps1 file and users credentials if
option {opt cred} is given.

{phang}				
{opt logname(filename)} is the name of the .log file created by the program.

{phang}				
{opt att} if specified will attach the .log file to the email.

{phang}				
{opt cred} if provided will call {cmd:pscred} and users will be asked for their email credentials. The 
	email address will be saved as a plain text file user.txt and the password will be saved as a secure string
	in pass.txt. Both files will be saved in {it:log_folder}. Upon sending the email these files will
	be automatically deleted unless {opt ndel} is given.

{phang}				
{opt smtpport(smtp port)} gives the smtp port number. By default it is set to that used by gmail.

{phang}				
{opt smtpsserver(smtp server)} gives the smtp server address which by default is the gmail smtp server.

{phang}				
{opt from(name)} is the name of the sender which by default is not provided.

{phang}				
{opt ufile(username file)} gives the location and filename of the users email address saved as plain text in
	a .txt file. The file extension should not be included. This file is required if {opt cred} is not given. Unlike
	{opt cred} this file will not be deleted upon completion of the program.

{phang}				
{opt pfile(password file)} gives the location and filename of the users password saved as a secure string in
	a .txt file. The file extension should not be included. This file is required if {opt cred} is not given. Unlike
	{opt cred} this file will not be deleted upon completion of the program. To generate a secure string {cmd pscred} can 
	be used.

{phang}				
{opt cc(cc_recipient)} is the email address included as a cc to the email.

{phang}				
{opt  nossl} specifies that the Secure Sockets Layer (SSL) to establish a connection is not used. 

{phang}				
{opt  nodel} specifies that user credentials created by a call to option {opt cred} will not be deleted 
if the .do file runs successfully. In the event that the .do file exits with error, credentials will be deleted
regardless of whether {opt ndel} is given. If credentials are provided by {opt ufile} and {opt pfile} then
credentials will never be deleted by {cmd:eofmail} and {opt ndel} is not required.

{phang}				
{opt  test(email_address)} sends a test email prior to running the .do file. This allows users to know in 
advance that emails are being sent correctly. A test email will be sent to the recipient and stata will 
request users interact with the console. Specifically users must enter on the console whether the email was
recieved successfully or not. If no email is received then the program will exit without running and any inputted 
credentials will be deleted (unless provided by {opt ufile} and {opt pfile}). Users should note that depending
on the email service used, emails may arrive with delay.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:eofmail} sends an email from a users email account on the successful or unsuccessful completion of a
.do file. User credentials can either be inputted directly if stored on the users system or captured by 
the program. In the latter case, a pop-up window will appear and ask for users to input their credentials
and the files storing the credentials will be deleted upon completion. Users credentials are captured
using {bf:{help pscred:pscred}}.

{pstd}
Though only a single .do file can be inputted to the program, this .do file can call upon other .do files
and the relevant error message will be captured in the same manner. Alternatively, it is possible to
run many .do files using successive calls to eofmail but requesting users credentials only once. More
information is contained in the examples below.

{pstd}
It is possible for users to send a test email before running the .do file. In this case a test email will be
sent and stata will pause and request that users tell stata that the email has been recieved before 
continuing. 

{pstd}
Emails are sent by calling the {bf:{help winmail:winmail}} program which sends email using smtp via windows
powershell. The program creates a .log file which is used to capture end-of-file error messages. A .ps1 script
is saved in the same location on the users system.

{pstd}
As this program makes use of windows powershell it can only be used on the windows operating system. 
Users who have not used windows powershell before should note that by default it may not have sufficient
administrative privileges to perform the operations in {cmd:winmail}. First time users should run  
"Set-ExecutionPolicy RemoteSigned" when running windows powershell as administrator and follow the
simple instructions on screen. This command specifies that scripts created on the current system 
and files with a digital signature may be run. This keeps powershell privileges quite strict but 
is sufficient for this program as the .ps1 script executed is created locally.

{pstd}
By default smtp settings are set to for gmail.com email accounts. Users should see the documentation for 
{bf:{help winmail:winmail}} for more information on using other email accounts.

{pstd}
{cmd:eofmail} requires {bf:{help pscred:pscred}} and {bf:{help winmail:winmail}} be installed. Additionally,
{bf:{help winmail:winmail}} requires that {bf:{help tknz:tknz}} be installed.


{marker examples}{...}
{title:Examples}

{pstd}{bf:Example 1: Running a .do file using eofmail}

{pstd}If edregs.do is stored in the current working directory {p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cred}{p_end}

{pstd}To attach the .log file{p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cr a}{p_end}

{pstd}To send a test email{p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cr a t(me@email.com)}{p_end}

{pstd}Specifying the location of the .do file and where to save the .log, .ps1 and .txt files{p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cr logf(C:\Users\proj) dof(C:\Users\dofiles) }{p_end}

{pstd}Inputting credentials stored on the system{p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) uf(C:\Users\user.txt) pf(C:\Users\pass.txt)}{p_end}


{pstd}{bf:Example 2: Running nested .do files}

{pstd}It is possible to run several nested .do files using eofmail. For instance if the following command 
is run: {p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cred}{p_end}

{pstd}edregs can make calls to various .do files. An email will be sent at any point in which the program
exits, regardless of in which .do file the error was found. {p_end}


{pstd}{bf:Example 3: Running several .do files in sequence}

{pstd}To run several .do files in order and obtain sequential updates users should can make successive calls to
{cmd:eofmail}, providing their credentials only once.{p_end}

{pstd}For example, users could run {p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) cr nodel logf(C:\Users\proj) t(me@email.com }{p_end}
{phang2}{cmd:. eofmail edregs2, to(me@email.com) uf(C:\Users\proj\user.txt) pf(C:\Users\proj\pass.txt)}{p_end}
{phang2}{cmd:. eofmail edregs3, to(me@email.com) uf(C:\Users\proj\user.txt) pf(C:\Users\proj\pass.txt)}{p_end}
{phang2}{cmd:. winexec powershell.exe Remove-Item "C:\Users\proj\user.txt"} {p_end}
{phang2}{cmd:. winexec powershell.exe Remove-Item "C:\Users\proj\pass.txt"} {p_end}

{pstd}which will ask users for credentials only once, and then use these credentials in the two latter commands.
A test email is also sent when the first command is run. Note that in the case that any of the previous .do files
exit with error, the following .do files will still be run. This means that if latter .do files are dependent 
on .do files run earlier, then errors may compound. Secondly, if the first .do file that captures users 
credentials exits with error, then users credentials will be deleted and emails will not be sent for 
latter cases. Finally, it is highly recommended that these files not remain on the users system and so the final lines
use windows powershell to delete these .txt files. An alternative would be for users to use 
{bf:{help erase:erase}}. {p_end}

{pstd} An alternative is to run:{p_end}
{phang2}{cmd:. pscred user pass, folderc(C:\Users\proj) del } {p_end}
{phang2}{cmd:. eofmail edregs, to(me@email.com) uf(C:\Users\proj\user.txt) pf(C:\Users\proj\pass.txt)}{p_end}
{phang2}{cmd:. eofmail edregs2, to(me@email.com) uf(C:\Users\proj\user.txt) pf(C:\Users\proj\pass.txt)}{p_end}
{phang2}{cmd:. eofmail edregs3, to(me@email.com) uf(C:\Users\proj\user.txt) pf(C:\Users\proj\pass.txt)}{p_end}
{phang2}{cmd:. winexec powershell.exe Remove-Item "C:\Users\proj\user.txt"} {p_end}
{phang2}{cmd:. winexec powershell.exe Remove-Item "C:\Users\proj\pass.txt"} {p_end}

{pstd}Where users credentials are stored following a call to {cmd:pscred} and available for use in all subsequent
.do files. {p_end}

{pstd}To summarise, when several .do files need to be run which are independent of one another, it is best to make
repeated use of eofmail, as an error in one .do file does not affect a latter program from running. When .do 
files are dependent it is better to nest them in a single do file as outlined in {bf:Example 2}. In this case
succesive uses of {cmd:eofmail} will lead to compounding errors. {p_end}


{marker author}{...}
{title:Author}

{pstd}Iain Snoddy{p_end}
{pstd}iainsnoddy@gmail.com{p_end}


