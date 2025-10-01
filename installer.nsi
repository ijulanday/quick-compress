!define APP_NAME "Quick Compress"
!define REG_NAME "QuickCompress"

# define the name of the installer
Outfile "QuickCompressSetup.exe"
 
# define the directory to install to
InstallDir "$PROGRAMFILES\${APP_NAME}"
 
# default section
Section

 
    # call UserInfo plugin to get user info.  The plugin puts the result in the stack
    UserInfo::GetAccountType
   
    # pop the result from the stack into $0
    Pop $0
 
    # compare the result with the string "Admin" to see if the user is admin.
    # If match, jump 3 lines down.
    StrCmp $0 "Admin" +3
 
    # if there is not a match, print message and return
    MessageBox MB_OK "not admin: $0\nplease run as administrator"
    Return
 
    # otherwise, confirm and return
    # MessageBox MB_OK "is admin"
    
    # define the output path for this file
    SetOutPath $INSTDIR

    # define what to install and place it in the output path
    File quick-compress.ps1
    File quick_compress_icon.ico

    # yay uninstaller
    WriteUninstaller "$INSTDIR\uninstaller.exe"

    # # # set up registry !!!! # # #
    # set the name up
    WriteRegStr HKCR "SystemFileAssociations\.mp4\shell\${REG_NAME}" "" "${APP_NAME}"   
    # get the icon in there
    WriteRegStr HKCR "SystemFileAssociations\.mp4\shell\${REG_NAME}" "Icon" "$INSTDIR\quick_compress_icon.ico"
    # finally the good stuff
    WriteRegStr HKCR "SystemFileAssociations\.mp4\shell\${REG_NAME}\command" "" "powershell.exe -NoProfile -ExecutionPolicy Bypass -File $\"$INSTDIR\quick-compress.ps1$\" $\"%1$\""
    # uninstall information
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${REG_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${REG_NAME}" "UninstallString" "$\"$INSTDIR\uninstaller.exe$\""

SectionEnd

# yay uninstaller
Section "Uninstall"

    Delete $INSTDIR\quick-compress.ps1

    Delete $INSTDIR\quick_compress_icon.ico

    Delete $INSTDIR\uninstaller.exe

    DeleteRegKey HKCR "SystemFileAssociations\.mp4\shell\${REG_NAME}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${REG_NAME}"

    RMDIR $INSTDIR

SectionEnd