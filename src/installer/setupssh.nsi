;This REQUIRES NSIS Modern User Interface Version 1.70 (NSIS 2.0-Final)

;OpenSSH for Windows 6.4p1
;Installer Script
;Written by Michael Johnson
;Based on script examples by Joost Verburg
;
;This script and related support files are licensed under the GPL

;Include ModernUI Components
!include "MUI.nsh"

;Extra Help Files - Path Addition and Deletion Functions
!include ".\InstallerSupport\Path.nsi"
!include ".\InstallerSupport\GetParent.nsi"

;General Variables (Installer Global ONLY)
Name "OpenSSH for Windows 6.4p1"                   ;The name of the product
SetCompressor bzip2                                  ;Use BZip2 Compression
OutFile "WinSSH.exe"                               ;This is the name of the output file
!packhdr tmp.dat "c:\upx\upx.exe --best -q tmp.dat"  ;Compress the NSIS header with UPX

;Interface Customization
!define "MUI_ICON" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Icons\orange-install.ico"
!define "MUI_UNICON" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Icons\orange-uninstall.ico"
!define "MUI_HEADERIMAGE_RIGHT"
!define "MUI_HEADERIMAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Header\orange-r.bmp"
!define "MUI_HEADERIMAGE_UNBITMAP" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Header\orange-uninstall-r.bmp"
!define "MUI_WELCOMEFINISHPAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Wizard\orange.bmp"
!define "MUI_UNWELCOMEFINISHPAGE_BITMAP" "${NSISDIR}\Contrib\Graphics\Orange-Full-MoNKi\Wizard\orange-uninstall.bmp"


;Variables used by the script
Var MUI_TEMP
Var STARTMENU_FOLDER

;The default install dir - The user can overwrite this later on
InstallDir "$PROGRAMFILES\OpenSSH"

;Check the Registry for an existing install directory choice (used in upgrades)
InstallDirRegKey HKLM "Software\OpenSSH for Windows" ""

;ModernUI Specific Interface Settings
!define MUI_ABORTWARNING                 ;Issue a warning if the user tries to reboot
;!define MUI_UI_COMPONENTSPAGE_SMALLDESC "${NSISDIR}\Contrib\UIs\modern-smalldesc.exe"  ;Show a smaller description area (under the components, instead of to the side

;StartMenu Configuration
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\OpenSSH for Windows"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

;Page Specific Settings
!define MUI_STARTMENUPAGE_NODISABLE                               ;User cannot disable creation of StartMenu icons
!define MUI_LICENSEPAGE_RADIOBUTTONS                              ;Use radio buttons for license acceptance
!define MUI_FINISHPAGE_NOREBOOTSUPPORT                            ;Disable the reboot suport section for the finish page - we don't reboot anyway
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "OpenSSH for Windows"     ;The default folder for the StartMenu
;!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\docs\quickstart.txt" ;The file linked as the readme

;Pages in the installer
!insertmacro MUI_PAGE_WELCOME                                 ;Welcome Page
!insertmacro MUI_PAGE_LICENSE "InstallerSupport\License.txt"  ;The license page, and the file to pull the text from
!insertmacro MUI_PAGE_COMPONENTS                              ;Software components page
!insertmacro MUI_PAGE_DIRECTORY                               ;Installation directory page
!insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER
!insertmacro MUI_PAGE_INSTFILES                               ;Show installation progress
!insertmacro MUI_PAGE_FINISH                                  ;Display the finish page

;Pages in the uninstaller
!insertmacro MUI_UNPAGE_WELCOME    ;Show Uninstaller welcome page
!insertmacro MUI_UNPAGE_CONFIRM    ;Show uninstaller confirmation page - Does the user _really_ want to remove this awesome software?
!insertmacro MUI_UNPAGE_INSTFILES  ;Show uninstallation progress
!insertmacro MUI_UNPAGE_FINISH     ;Show uninstaller finish page

;Set the language we want the installer to be in (note this only applies for Installer-specific strings - everything else is in English)
!insertmacro MUI_LANGUAGE "English"

;Installer process sections - This is where the actual install takes place
!include ".\InstallerSupport\InstallerProcess.nsi"

;Descriptions - These are used when the component is moused-over and display in the description box
!include ".\InstallerSupport\Descriptions.nsi"

;Section for uninstaller process
!include ".\InstallerSupport\UnInstallerProcess.nsi"





Function .onInit

  ;Check for other Cygwin apps that could break

  ;Look for old-style SSH install
  IfFileExists "c:\ssh" PriorCygwin

  ;Look for Cygwin install
  IfFileExists "c:\cygwin" PriorCygwin

  ;Look for the Cygwin mounts registry structure
  ReadRegStr $7 HKLM "SOFTWARE\Cygnus Solutions\Cygwin\mounts v2\/" "native"

  ;Look and see if read failed (good thing)
  IfErrors ContinueInstall PriorCygwin

  ;Error messsage and question user
  PriorCygwin:
    ;Prompt. Ask if user wants to continue
    MessageBox MB_YESNO|MB_ICONINFORMATION "It appears that either cygwin or an earlier version of the OpenSSH for Windows package is installed, because setup is detecting Cygwin registry mounts (HKLM\SOFTWARE\Cygnus Solutions\...). If you're upgrading an OpenSSH for Windows package you can ignore this, but if not you should stop the installation.  Keep going?" IDYES ContinueInstall
    ;If user does not want to continue, quit
    Quit

  ;Continue Installation, called if no prior cygwin or user wants to continue
  ContinueInstall:
    ;Set output to the ssh subdirectory of the install path
    SetOutPath $TEMP\bin

    ;Add the cygwin service runner to the output directory
    File bin\cygrunsrv.exe
    File bin\cygwin1.dll

    ;Find out if the OpenSSHd Service is installed
    Push 'OpenSSHd'
    Services::IsServiceInstalled
    Pop $0
    ; $0 now contains either 'Yes', 'No' or an error description
    StrCmp $0 'Yes' RemoveServices SkipRemoval



    ;This will stop and remove the OpenSSHd service if it is running.
    RemoveServices:
      push 'OpenSSHd'
      push 'Stop'
      Services::SendServiceCommand

      push 'OpenSSHd'
      push 'Delete'
      Services::SendServiceCommand
      Pop $0
      StrCmp $0 'Ok' Success
      MessageBox MB_OK|MB_ICONSTOP 'The installer found the OpenSSH for Windows service, but was unable to remove it. Please stop it and manually remove it. Then try installing again.'
      Abort

      Success:

    SkipRemoval:

FunctionEnd
