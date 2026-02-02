; DataManager 安装程序脚本

[Setup]
AppName=标注数据管理平台
AppVersion=1.0
DefaultDirName={autopf}\数据管理平台
DefaultGroupName=数据管理平台
OutputDir=dist_installer
OutputBaseFilename=数据管理平台_Setup_v1.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; 主程序 (对应 main.spec 中定义的文件名)
Source: "dist\数据管理平台.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\数据管理平台"; Filename: "{app}\数据管理平台.exe"
Name: "{autodesktop}\数据管理平台"; Filename: "{app}\数据管理平台.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\数据管理平台.exe"; Description: "{cm:LaunchProgram,数据管理平台}"; Flags: nowait postinstall skipifsilent
