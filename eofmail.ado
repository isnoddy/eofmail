*! version 1.0 	 6 December 2016	Author: Iain Snoddy, iainsnoddy@gmail.com

/*
This program runs a .do file and captures any associated error messages
that cause the .do to exit before completion. It sends an email from
a specified users email to another specified addess on completion.
The email specifies if the .do ran sucessfully or with error.
*/

program define eofmail
	version 12
	syntax anything(name=dofile) ,[DOFolder(string) LOGName(string) ///
		LOGFolder(string) to(string) Att CRed ndel UFile(string) PFile(string) ///
		SMTPServer(string) SMTPPort(string) FRom(string) cc(string) nossl Test(string) ]
		
		
	if "`to'"==""{	
		di as error "to() option required."
		exit 
	}
	if "`cred'"!="" & "`ufile'"!="" {
		di as error `"Options cred and ufile() cannot be specified jointly"'
		exit
	}
	if  "`cred'"!="" & "`pfile'"!=""{
		di as error `"Options cred and pfile() cannot be specified jointly"'
		exit
	}
	if "`cred'"=="" & "`ufile'"=="" | "`cred'"=="" & "`pfile'"=="" {
		di as error "If option cred is not specified then the location of credentials"
		di as error "must be provided in ufile() and pfile()"
		exit
	}

	if "`logname'"=="" local logname eoflog
	if "`dofolder'"=="" local dofolder `c(pwd)'
	if "`logfolder'"=="" local logfolder `c(pwd)'
	
	if "`cred'"!="" {
		pscred user pass, folderc(`logfolder') del
		local ufile "`logfolder'\user"
		local pfile "`logfolder'\pass"
	}
	
	if "`test'"!=""{
		winmail `test', s(Test email) b(Success!) ufile(`ufile') psloc(`logfolder') ///
			pfile(`pfile') smtpport(`smtpport') smtpserver(`smtpserver') from(`from') cc(`cc') `nossl'
			
		display "Did you receive Test email? If yes, type [Y] to continue. If not, type [N] to exit the program." _request(yn)
		if "$yn"=="N" | "$yn"=="[N]" {
			if "`cred'"==""{
				display "The files storing your username and password will not be deleted and the program will end"
				exit
			}
			else{
				display "The files storing your username and password will now be deleted and the program will exit"
				winexec powershell.exe Remove-Item `ufile'.txt
				winexec powershell.exe Remove-Item `pfile'.txt
				exit
			}
		}
		else display "Sweet! The program will now continue running"
	}
	
	log using `logfolder'\\`logname',replace t name(logfile)
	capture noisily do `dofolder'\\`dofile'.do
	qui log close logfile
	
	local rc _rc

	if `rc'==0{	
		capture noisily {	
			local emailcontents "You nailed it! Your program ran successfully without error"
			if "`att'"!="" local attfile "`logfolder'\\`logname'.log"
			else local attfile ""
			
			winmail `to', s(`dofile') b("`emailcontents'") att(`attfile') ufile(`ufile') psloc(`logfolder') ///
					pfile(`pfile') smtpport(`smtpport') smtpserver(`smtpserver') from(`from') cc(`cc') `nossl'
		sleep 2000
		}		
	}
	else{
		capture noisily{
			file open loghandle using `logfolder'\\`logname'.log, read
			file read loghandle local_log
			
			local lastline=-2
			while r(eof)==0{
				local lastline=`lastline'+1
				file read loghandle local_log
			}
			
			local stop=1
			while `stop'==1{
				file seek loghandle tof				
				forvalues i=1/`lastline'{
					file read loghandle local_log	
					if `i'==`lastline'-1 local check1 "`local_log'"
				}
				if "`check1'"!="end of do-file" local stop=0
				else local lastline=`lastline'-3
			}	
			
			file seek loghandle tof				
			forvalues i=1/`lastline'{
				file read loghandle local_log	
				if `i'==`lastline'-2{
					if substr("`local_log'",1,1) == "."	local local_log = substr("`local_log'", 2, .)
					local local_log=substr("`local_log'",indexnot("`local_log'"," "),.)
					local errormsg "`local_log' |"
				}
				if `i'>=`lastline'-1 local errormsg "`errormsg' `local_log' |"
			}
			file close loghandle
									
			local emailcontents "Unfortunately things didn't go as planned." ///
			" But that's OK. It will be better next time. Here is the error message:|" 	
			
			local emailcontents `emailcontents' `errormsg'
						
			if "`att'"!="" local attfile "`logfolder'\\`logname'.log"
			else local attfile ""
			
			winmail `to', s(`dofile') b("`emailcontents'") att(`attfile') ufile(`ufile') psloc(`logfolder') ///
				pfile(`pfile') smtpport(`smtpport') smtpserver(`smtpserver') from(`from') cc(`cc') `nossl'	///
				html("1 <b> 2 <br> 3 <br> 4 </b>") par(1)
				sleep 2000
		}		
	}	

	if "`ndel'"=="" & "`cred'"!="" | "`cred'"!="" & _rc!=0{
		sleep 10000
		winexec powershell.exe Remove-Item `ufile'.txt
		winexec powershell.exe Remove-Item `pfile'.txt
	}
	
	end
