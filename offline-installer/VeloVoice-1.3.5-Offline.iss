#define MyAppName "VeloVoice"
#define MyAppVersion "1.3.5"
#define MyAppPublisher "VeloVoice community package"
#ifndef SourceDir
  #define SourceDir "payload"
#endif
#ifndef LicenseFilePath
  #define LicenseFilePath "LICENSE-GPL-3.0.txt"
#endif

[Setup]
AppId={{D50A3D66-3E93-4DF8-BA0E-5B6E41C0E135}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={localappdata}\Programs\VeloVoice
DefaultGroupName=VeloVoice
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
OutputBaseFilename=VeloVoice-1.3.5-Offline-Setup-x64
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
LicenseFile={#LicenseFilePath}
UninstallDisplayIcon={app}\VeloVoice.exe
SetupLogging=yes
Uninstallable=yes
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "chinesesimp"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加快捷方式："; Flags: unchecked

[Dirs]
Name: "{app}\logs"; Flags: uninsneveruninstall
Name: "{app}\output"; Flags: uninsneveruninstall
Name: "{app}\data"; Flags: uninsneveruninstall

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\VeloVoice"; Filename: "{app}\VeloVoice.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\VeloVoice"; Filename: "{app}\VeloVoice.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\VeloVoice.exe"; Description: "启动 VeloVoice"; Flags: postinstall nowait skipifsilent