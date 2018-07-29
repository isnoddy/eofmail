# eofmail

Stata module that sends an email on the completion of a .do file. An email is sent using winmail informing users if the program ran successfully or with error. In the event that the program exited with error the email message will contain the error message and if desired, the .log file. 

A successful email message will contain the text body: "You nailed it! Your program ran successfully without error." An unsuccessful email will contain: "Unfortunately things didn't go as planned. But that's OK. It will be better next time. Here is the error message:" followed by the error message.

The stata help file for the program provides some useful guidance on how to use eofmail when tasks are separated into a series of sequential .do files or into one nested .do file.

*Suggested use*: This program was created because I found myself performing very time intensive operations with no idea on when they would end and whether they would run successfully or with error. There is nothing more frustrating than leaving a program for several hours thinking it is running when it stumbled upon an error in the first 15 minutes! This program is ideal when performing very long tasks to ensure you are not checking your computer incessantly.

*Dependencies*: pscred, tknz, winmail and Windows Powershell be installed on the users system
