Section "Shared Tools" Shared
  SectionIn RO

  ;Set the output to the bin directory
  SetOutPath $INSTDIR\bin

  ;Extract the files to the above directory
  File bin\cygiconv-2.dll
  File bin\cygintl-8.dll
  File bin\cygminires.dll
  File bin\chown.exe
  File bin\chmod.exe
  File bin\scp.exe
  File bin\mkgroup.exe
  ;File bin\mkpasswd.c
  File bin\mkpasswd.exe
  File bin\ssh-keygen.exe
  File bin\ssh-keyscan.exe
  File bin\ssh-agent.exe
  File bin\cygz.dll
  ;File bin\cygcrypto-0.9.7.dll
  File bin\cygcrypto-1.0.0.dll
  File bin\cygwin1.dll
  File bin\ssh-add.exe
  File bin\cygz.dll
  File bin\cygreadline7.dll
  File bin\cygncursesw-10.dll
  File bin\cyggcc_s-1.dll
  File bin\cygssp-0.dll
  File bin\cygcrypt-0.dll

  ;Set the output to the docs directory
  SetOutPath $INSTDIR\docs

  ;Extract the files to the above directory
  File docs\changelog.txt
  File docs\key_authentication.txt
  File docs\ssh-keygen-manual.htm
  File docs\ssh-keyscan-manual.htm
  File docs\ssh-agent-manual.htm
  File docs\readme.txt
  File docs\quickstart.txt
  File docs\ssh-keygen-manual.htm
  File docs\ssh-add-manual.htm
  File docs\cygwin-GPL.txt
  File docs\openssh-license.txt

  ;Create /tmp directory
  CreateDirectory $INSTDIR\tmp

  ;Write the Registry Structure for CYGWIN
  WriteRegStr HKLM "Software\Cygnus Solutions\Cygwin\Program Options" "" ""

  ; /
  WriteRegStr HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/" "native" "$INSTDIR"
  WriteRegDWORD HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/" "flags" "10"

  ; /usr/bin
  WriteRegStr HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/usr/bin" "native" "$INSTDIR/bin"
  WriteRegDWORD HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/usr/bin" "flags" "10"

  ; /home (The Profiles directory for the machine)

  ;Profile directories usually only reside on NT machines. This will set /home to the profiles directory only on NT. If on 9x, it will use $INSTDIR/bin
  ReadEnvStr $7 "OS"
  ;If the OS environment variable is Windows_NT, this will goto IsOK, if not, it goes to SkipServer
  StrCmp $7 "Windows_NT" 0 Win9xHome

    ;Find the profiles directory
    ;Find the user's personal directory by getting the directory below their startmenu directory
    Push $STARTMENU
    Call GetParent
    Pop $R0

    ;Find the directory that holds the user's profile. This will hold the profiles of other users.
    Push $R0
    Call GetParent
    Pop $R0

    WriteRegStr HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/home" "native" "$R0"
    WriteRegDWORD HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/home" "flags" "10"

    Goto EndNT

  Win9xHome:
    WriteRegStr HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/home" "native" "$INSTDIR/bin"
    WriteRegDWORD HKLM "Software\Cygnus Solutions\Cygwin\mounts v2\/home" "flags" "10"

  EndNT:



  ;Write the CYGWIN environment variable
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "CYGWIN" "tty"

  ;Check if directory is in path
  ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "PATH"
  Push $1

  ;Add the installation directory to the path
  Push "$INSTDIR\bin"

  Call StrStr

  Pop $1

  IntCmp $1 -1 0 0 There

    ;Add the installation directory to the path
    Push "$INSTDIR\bin"

    Call AddToPath

  There:

SectionEnd

Section "Client" Client
  ;Set the output to the bin directory
  SetOutPath $INSTDIR\bin

  ;Extract the files to the above directory
  File bin\ssh.exe
  File bin\sftp.exe

  ;Set the output to the docs directory
  SetOutPath $INSTDIR\docs

  ;Extract the files to the above directory
  File docs\scp-manual.htm
  File docs\sftp-manual.htm
  File docs\ssh-manual.htm

  ;Set the output to the usr\share\terminfo\c directory
  SetOutPath $INSTDIR\usr\share\terminfo\c

  ;Extract the files to the above directory
  File usr\share\terminfo\c\cygwin
SectionEnd

Section "Server" Server
  ;The Server can only be installed on NT, check the OS.
  ReadEnvStr $7 "OS"
  ;If the OS environment variable is Windows_NT, this will goto IsOK, if not, it goes to SkipServer
  StrCmp $7 "Windows_NT" 0 SkipServer

  ;Backup the old configuration and keys

  ;Create backup directorys to hold the files
  CreateDirectory "$INSTDIR\etc\backup"

  ;Copy the files to the backup folders
  CopyFiles /SILENT "$INSTDIR\etc\*.*" "$INSTDIR\etc\backup\"     ;The Configuration and keys

  ;Remove the backed-up files
  Delete "$INSTDIR\etc\*.*"

  ;Copy the Server Files

  ;Set the output to the bin directory
  SetOutPath $INSTDIR\bin

  ;Extract the files to the above directory
  File bin\cygrunsrv.exe
  File bin\quietcmd.bat
  File bin\sh.exe
  File bin\false.exe
  File bin\ls.exe
  File bin\mkdir.exe
  File bin\rm.exe
  File bin\switch.c
  File bin\switch.exe
  File bin\last.exe

  ;Set the output to the ssh directory
  SetOutPath $INSTDIR\usr\sbin

  ;Extract the files to the above directory
  File usr\sbin\sftp-server.exe
  File usr\sbin\sshd.exe
  File usr\sbin\ssh-keysign.exe

  ;Set the output to the docs directory
  SetOutPath $INSTDIR\docs

  ;Extract the files to the above directory
  File docs\sshd-manual.htm
  File docs\sshd-config-manual.htm
  File docs\sftp-server-manual.htm
  File docs\last-copyright.txt

  ;Set the output to the etc directory
  SetOutPath $INSTDIR\etc

  ;Extract the files to the above directory
  File etc\banner.txt
  File etc\sshd_config
  File etc\ssh_config
  File etc\moduli

  ;Set the output to the var\log directory
  SetOutPath $INSTDIR\var\log

  ;Extract the files to the above directory
  File var\log\lastlog
  File var\log\wtmp

  ;Set the output to the var\run directory
  SetOutPath $INSTDIR\var\run

  ;Extract the files to the above directory
  File var\run\utmp

  ;Move the backup files into their normal locations
  CopyFiles /SILENT "$INSTDIR\etc\backup\*.*" "$INSTDIR\etc"
  ;Remove the backup folders, as they are no longer needed
  RMDir /r "$INSTDIR\etc\backup"

  ;Look for existing keys, if not found, generate keys
  IfFileExists $INSTDIR\etc\*host* EndSection

  ExecWait `$INSTDIR\bin\ssh-keygen.exe -t dsa -f /etc/ssh_host_dsa_key -N ""` ;Creates a SSH2 DSA key
  ExecWait `$INSTDIR\bin\ssh-keygen.exe -t rsa1 -f /etc/ssh_host_key -N ""`    ;Creates a SSH1 RSA key
  ExecWait `$INSTDIR\bin\ssh-keygen.exe -t rsa -f /etc/ssh_host_rsa_key -N ""` ;Creates a SSH2 RSA key

  ;If no keys were generated, this section is called. It is also called after keys have been generated
  ;This section displays a notice about configuring the passwd file for server access
  EndSection:
    ;Install the OpenSSHd Service

    ;The ACLs need change to let cygrunsrv properly work with the service
    ; chmod is still not working - need to use cacls until this can be worked out
    ;nsExec::Exec  'chmod -R 755 "$INSTDIR"'
    ;nsExec::Exec  'chmod -R 644 "$INSTDIR\etc"'

    ;Get the current username and domain for ACL changes
    ReadEnvStr $2 "USERDOMAIN"
    ReadEnvStr $3 "USERNAME"

    ;Add correct permissions
    nsExec::Exec 'cacls "$INSTDIR" /E /T /G $2\$3:F'
    nsExec::Exec 'cacls "$INSTDIR" /E /T /G SYSTEM:F'
    nsExec::Exec `$INSTDIR\bin\cygrunsrv --install OpenSSHd --path /usr/sbin/sshd --args "-D" --dep "Tcpip" --stderr "/var/log/opensshd.log" --env "CYGWIN=binmode ntsec tty" --disp "OpenSSH Server"`


    MessageBox MB_OK|MB_ICONINFORMATION "Before starting the OpenSSH service you MUST edit the $INSTDIR\etc\passwd file.  If you don't do this, you will not be able to log in through the SSH server.  Please read the readme.txt or quickstart.txt file for information regarding proper setup of the passwd file."
    Return


  SkipServer:
    MessageBox MB_OK|MB_ICONEXCLAMATION "You cannot install the server unless you're running Windows NT or Windows 2000.  The server installation will be skipped."

SectionEnd

Section "Start Menu Shortcuts" Shortcuts
;By default, this section runs will all install types
SectionIn 1 2 3
  ;Set the context to all users
  SetShellVarContext all
  ;These Entries below create shortcuts to the documentation for the program
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Key Based Authentication.lnk" "$INSTDIR\docs\key_authentication.txt"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Readme.lnk" "$INSTDIR\docs\readme.txt"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Quick Start Guide.lnk" "$INSTDIR\docs\quickstart.txt"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\OpenSSH for Windows Web Site.url" "http://sshwindows.sourceforge.net/"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Remove OpenSSH for Windows.lnk" "$INSTDIR\uninstall.exe"

    ;Write shortcut location to the registry (for Uninstaller)
;    WriteRegStr HKLM "Software\${PRODUCT}" "Start Menu Folder" "$STARTMENU_FOLDER"

  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section "-PostInstall"
  ;This section is required
  SectionIn RO

  ;This command creates an uninstall program
  WriteUninstaller $INSTDIR\uninstall.exe

  ;Set the context to all users
  SetShellVarContext all

  ;Add a shortcut to the startmenu/programs for uninstallation
  CreateShortCut "$SMPROGRAMS\OpenSSH\Remove OpenSSH for Windows.lnk" "$INSTDIR\uninstall.exe"

  ;Add a link to the Add/Remove Programs Control Panel Applet
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "DisplayName" "OpenSSH for Windows (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "UninstallString" '"$INSTDIR\uninstall.exe"'

  ;Add Support Information to Add/Remove Control Panel Applet
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "Contact" 'youngmug@hotmail.com'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "DisplayIcon" '"$INSTDIR\uninstall.exe",0'
;  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "DisplayVersion" '${VERSION}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "HelpLink" "http://sshwindows.sourceforge.net/"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "Publisher" 'Michael Johnson'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "Readme" '$INSTDIR\docs\readme.txt'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "URLInfoAbout" "http://sshwindows.sourceforge.net/"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenSSH" "URLUpdateInfo" "http://sshwindows.sourceforge.net/"

SectionEnd
