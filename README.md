WinSSH
======

OpenSSH (7.2p2) for Windows 
=======


General Features

    * Security, if you want to access your Windows Machines cmd shell with full security.
    * Windows NT Service Support
    * Full install about 5mb, installer under 4mb (Cygwin dependcies has increased the size)
    * Windows Command Prompt support for SSH Terminal
    * SCP/SFTP server support (secure file transfer)
    * Command-line clients included
    * Added tail command

Download Setup from : https://github.com/babarnazmi/WinSSH/raw/master/downloads/WinSSH.exe
For more information and comments please visit : http://blogs.silicontechnix.com/?p=934

Install
-------

Run the setup program and accept the defaults (all categories).
This will install the OpenSSH server and client in an appropiate place.


Configuration
-------------
1.  Open a command prompt and change to the installation directory (Program Files\OpenSSH is the default).

2.  CD into the bin directory.

3.  Use mkgroup to create a group permissions file. For local groups, use the "-l" switch. For domain groups, use the "-d" switch.
    For both domain and local, it is best to run the command twice (remember to use >>, not >). If you use both, make sure to edit the file to remove any duplicate entires.

      mkgroup -l >> ..\etc\group      
      (-l is for local groups)
      
      mkgroup -d >> ..\etc\group      
      (-d is for domain groups)

4.  Use mkpasswd to add authorized users into the passwd file. For local users, use the "-l" switch. For domain users, use the "-d" switch.
    For both domain and local, it is best to run the command twice (remember to use >>, not >). If you use both, make sure to edit the file to remove any duplicate entires.

      mkpasswd -l [-u <username>] >> ..\etc\passwd      
      (-l is for local users)
      
      mkpasswd -d [-u <username>] >> ..\etc\passwd      
      (-d if for domain users)

    NOTE: To add users from a domain that is not the primary domain of the machine, add the domain name after the user name.
    NOTE: Ommitting the username switch adds ALL users from the machine or domain, including service accounts and the Guest account.

5.  Start the OpenSSH server.

      net start "openssh server"

6.  Test the server. Using a seperate machine as the client is best. If you connect but the connection immediately gets dropped, reboot the machine with the server and try connecting again.


