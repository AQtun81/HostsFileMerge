param (
  [string[]]$Sources,
  [int]$Aliases = 9,
  [string]$IPFormat = "0.0.0.0",
  [string]$Install = "False"
)

#region --- SET-UP

if ($Aliases -lt 1) {$Aliases = 1}

try {
  [bool]$Install = [System.Convert]::ToBoolean($Install)
}
catch {
  [bool]$Install = $False
}

[System.Collections.ArrayList]$script:Domains = @()
[string[]]$script:SourcesURL = @()
$script:RemoveDomains = "localhost", "localhost.localdomain", "local", "broadcasthost", "localhost", "ip6-localhost", "ip6-loopback", "localhost", "ip6-localnet", "ip6-mcastprefix", "ip6-allnodes", "ip6-allrouters", "ip6-allhosts", "0.0.0.0"
[string[]]$script:HostsListName = @()
[string[]]$script:HostsListURL = @()

function Add-Hosts-Source([string]$URL, [string]$Name) {
  $script:HostsListName += $Name
  $script:HostsListURL += $URL
}

Add-Hosts-Source "https://adaway.org/hosts.txt" "adaway"
Add-Hosts-Source "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" "StevenBlack"
Add-Hosts-Source "https://winhelp2002.mvps.org/hosts.txt" "MVP"
Add-Hosts-Source "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" "Yoyos"
Add-Hosts-Source "https://sysctl.org/cameleon/hosts" "Cameleon"
Add-Hosts-Source "https://someonewhocares.org/hosts/hosts" "someonewhocares"
Add-Hosts-Source "https://www.malwaredomainlist.com/hostslist/hosts.txt" "malwaredomainlist"
Add-Hosts-Source "https://www.hostsfile.org/Downloads/hosts.txt" "hostsfileorg"
Add-Hosts-Source "https://raw.githubusercontent.com/lewisje/jansal/master/adblock/hosts" "jansal"
Add-Hosts-Source "https://raw.githubusercontent.com/yous/YousList/master/hosts.txt" "YousList"

#endregion

#region --- USER INTERFACE

function Get-Selected-Radio-Value($Panel) {
  foreach ($Radio in $Panel) {
    if ($Radio.Checked) {
      return $Radio.Text
    }
  }
}

function get-arguments-from-interface {
  $IPArg = ""
  $AliasesArg = ""
  $SourcesArg = " -Sources " + ($SourcesListGUI.CheckedItems -join ",")
  $InstallArg = ""

  if ($ApplyCheckBox.Checked) {
    $InstallArg = " -Install `$True"
  }

  switch (Get-Selected-Radio-Value $BlockingIPRadioArray)
  {
      "Use 127.0.0.1" {$IPArg = " -IPFormat `"127.0.0.1`""}
  }
  
  switch (Get-Selected-Radio-Value $AliasLimitRadioArray)
  {
      "35 (Linux)" {$AliasesArg = " -Aliases 35"}
      "Don't use aliases" {$AliasesArg = " -Aliases 1"}
  }

  return (-join ($SourcesArg, $InstallArg, $IPArg, $AliasesArg))
}

# open interface only when params are not supplied
if ($Sources.Count -eq 0) {

  Write-Host "Opening configuration interface..."
  Write-Host ""
  Add-Type -AssemblyName System.Windows.Forms
  [System.Windows.Forms.Application]::EnableVisualStyles()
  $Form = New-Object System.Windows.Forms.Form
  $Form.ShowIcon = $False
  $Form.Text = "Hosts file merge - configuration interface"
  $Form.StartPosition = 'CenterScreen'
  $Form.Size = '400, 540'
  $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

  # --- BLOCKING IP CHOICE
  $BlockingIPPanel = New-Object System.Windows.Forms.Panel
  $BlockingIPPanel.Location = '10, 10'
  $BlockingIPPanel.size = '400, 60'

  $BlockingIPPanelLabel = New-Object System.Windows.Forms.Label
  $BlockingIPPanelLabel.Location = '0, 0'
  $BlockingIPPanelLabel.Size = '350, 20'
  $BlockingIPPanelLabel.Text = 'Select blocking IP:'

  # --- BLOCKING IP CHOICE - RADIO BUTTONS
  [System.Windows.Forms.RadioButton[]]$BlockingIPRadioArray = @()

  $BlockingIPRadioArray += New-Object System.Windows.Forms.RadioButton
  $BlockingIPRadioArray[0].Location = '0, 20'
  $BlockingIPRadioArray[0].Size = '350, 20'
  $BlockingIPRadioArray[0].Checked = $True 
  $BlockingIPRadioArray[0].Text = "Use 0.0.0.0 (Better for Windows 8.1+)"

  $BlockingIPRadioArray += New-Object System.Windows.Forms.RadioButton
  $BlockingIPRadioArray[1].Location = '0, 40'
  $BlockingIPRadioArray[1].Size = '350, 20'
  $BlockingIPRadioArray[1].Checked = $False
  $BlockingIPRadioArray[1].Text = "Use 127.0.0.1"

  $BlockingIPPanel.Controls.AddRange(@($BlockingIPPanelLabel, $BlockingIPRadioArray[0], $BlockingIPRadioArray[1]))
  $Form.Controls.Add($BlockingIPPanel)

  # --- ALIAS LIMIT CHOICE
  $AliasLimitPanel = New-Object System.Windows.Forms.Panel
  $AliasLimitPanel.Location = '10, 80'
  $AliasLimitPanel.size = '400, 90'

  $AliasLimitPanelLabel = New-Object System.Windows.Forms.Label
  $AliasLimitPanelLabel.Location = '0, 0'
  $AliasLimitPanelLabel.Size = '350, 20'
  $AliasLimitPanelLabel.Text = 'Select alias limit:'

  # --- ALIAS LIMIT CHOICE - RADIO BUTTONS
  [System.Windows.Forms.RadioButton[]]$AliasLimitRadioArray = @()

  $AliasLimitRadioArray += New-Object System.Windows.Forms.RadioButton
  $AliasLimitRadioArray[0].Location = '0, 20'
  $AliasLimitRadioArray[0].Size = '350, 20'
  $AliasLimitRadioArray[0].Checked = $True 
  $AliasLimitRadioArray[0].Text = "9  (Windows)"

  $AliasLimitRadioArray += New-Object System.Windows.Forms.RadioButton
  $AliasLimitRadioArray[1].Location = '0, 40'
  $AliasLimitRadioArray[1].Size = '350, 20'
  $AliasLimitRadioArray[1].Checked = $False
  $AliasLimitRadioArray[1].Text = "35 (Linux)"

  $AliasLimitRadioArray += New-Object System.Windows.Forms.RadioButton
  $AliasLimitRadioArray[2].Location = '0, 60'
  $AliasLimitRadioArray[2].Size = '350, 20'
  $AliasLimitRadioArray[2].Checked = $False
  $AliasLimitRadioArray[2].Text = "Don't use aliases"

  $AliasLimitPanel.Controls.AddRange(@($AliasLimitPanelLabel, $AliasLimitRadioArray[0], $AliasLimitRadioArray[1], $AliasLimitRadioArray[2]))
  $Form.Controls.Add($AliasLimitPanel)

  # --- SOURCES LIST
  $SourcesListGUI = New-Object System.Windows.Forms.CheckedListBox
  $SourcesListGUI.CheckOnClick = $True
  $SourcesListGUI.Location = New-Object System.Drawing.Point(10, 170)
  $SourcesListGUI.Size = New-Object System.Drawing.Size(($Form.Size.Width - 36), 260)
  $SourcesListGUI.Items.AddRange($script:HostsListName);
  $SourcesListGUI.DisplayMember = 'Caption'
  $Form.Controls.Add($SourcesListGUI)

  # --- APPLY CHECK BOX
  $ApplyCheckBox = New-Object System.Windows.Forms.CheckBox
  $ApplyCheckBox.Location = New-Object System.Drawing.Point(10, 430)
  $ApplyCheckBox.Size = New-Object System.Drawing.Size(220, 25)
  $ApplyCheckBox.Text = "Replace Hosts file on this machine"
  $Form.Controls.Add($ApplyCheckBox)

  # --- OK BUTTON
  $OkButton = New-Object System.Windows.Forms.Button
  $OkButton.Text = 'Ok'
  $OkButton.DialogResult = 'Ok'
  $OkButton.Location = New-Object System.Drawing.Point(($Form.Size.Width - 166), 450)
  $OkButton.Size = New-Object System.Drawing.Size(140, 40)
  $Form.Controls.Add($OkButton)

  # --- COPY COMMAND BUTTON
  $CopyCommand = {Set-Clipboard (-join ("powershell -executionpolicy remotesigned -Command `"& ([scriptblock]::Create((irm http://localhost/MergeHostsGUI.ps1)))", (get-arguments-from-interface), "`""))}
  $CopyCommandButton = New-Object System.Windows.Forms.Button
  $CopyCommandButton.Text = 'Copy Command'
  $CopyCommandButton.Location = New-Object System.Drawing.Point(10, 465)
  $CopyCommandButton.Size = New-Object System.Drawing.Size(100, 25)
  $CopyCommandButton.Add_Click($CopyCommand)
  $Form.Controls.Add($CopyCommandButton)

  function Enable-Sources-List-Item([string]$ItemName) {
    for ($i = 0; $i -lt $SourcesListGUI.Items.Count; $i++) {
      if ($SourcesListGUI.Items[$i] -eq $ItemName) {
        $SourcesListGUI.SetItemChecked($i, $True)
        break
      }
    }
  }

  Enable-Sources-List-Item("adaway")
  Enable-Sources-List-Item("StevenBlack")
  Enable-Sources-List-Item("MVP")

  $WindowConfirmation = $Form.ShowDialog()

  # Exit if user calcelled or no sources are selected
  if (($WindowConfirmation -ne "Ok") -or ($SourcesListGUI.CheckedItems.Count -le 0))
  {
    Write-Host "No sources selected"
    Exit
  }

  $Sources = $SourcesListGUI.CheckedItems
  $Install = $ApplyCheckBox.Checked
  
  switch (Get-Selected-Radio-Value $BlockingIPRadioArray)
  {
      "Use 0.0.0.0 (Better for Windows 8.1+)" {$IPFormat = "0.0.0.0"}
      "Use 127.0.0.1" {$IPFormat = "127.0.0.1"}
  }
  
  switch (Get-Selected-Radio-Value $AliasLimitRadioArray)
  {
      "9  (Windows)" {$Aliases = 9}
      "35 (Linux)" {$Aliases = 35}
      "Don't use aliases" {$Aliases = 1}
  }
} else {
  Write-Host ""
  Write-Host ""
}

#endregion

#region --- DISPLAY INFORMATION

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Using Sources:"$Sources
Write-Host "Alias Count:"$Aliases
Write-Host "IP Format:"$IPFormat
Write-Host "Auto-Install:"$Install
Write-Host ""

function Is-Administrator {
  return (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-Not (Is-Administrator) -And $Install) {
  Write-Host "Administrator Privileges Required!"
  # RELAUNCH SCRIPT WITH ADMINISTRATOR PRIVILAGES
  $ArgumentList = ""
  if ($Sources.Count -eq 0) { # USING GUI
    $ArgumentList = (-join ("-executionpolicy remotesigned -Command `"& ([scriptblock]::Create((irm http://localhost/MergeHostsGUI.ps1)))", (get-arguments-from-interface), "`""))
  } else {                    # USING CLI
    $SourcesArg = " -Sources " + ($Sources -join ",")
    $AliasesArg = " -Aliases " + $Aliases
    $IPFormatArg = " -IPFormat " + $IPFormat
    $InstallArg = " -Install `$True"
    $ArgumentList = (-join ("-executionpolicy remotesigned -Command `"& ([scriptblock]::Create((irm http://localhost/MergeHostsGUI.ps1)))", $SourcesArg, $AliasesArg, $IPFormatArg, $InstallArg, "`""))
  }
  start-process -verb runas -ArgumentList $ArgumentList powershell
  Exit
}

#endregion

#region --- INSTALLATION

function Donwload-And-Filter-Hosts([string]$URL, [string]$Name)
{
  Write-Host (-join ("Downloading Hosts File (", $Name, ")"))
  $Downloaded = Invoke-WebRequest -UseBasicParsing -Uri $URL

  Write-Host (-join ("Formatting Hosts File (", $Name, ")"))
  $Filtered = ($Downloaded.Content -Replace '[" "\t]*#.*', '' -Replace '.* ', '' | Where-Object { $_ -notmatch "^#" -and $_.trim() -ne "" }) -Split "`n"
  
  Write-Host (-join ("Loading Hosts File Into List (", $Name, ")"))
  foreach ($currentDomain in $Filtered) {
    $script:Domains.Add($currentDomain) | Out-Null
  }

  Write-Host " "
  $script:SourcesURL += $URL
}

foreach ($s in $Sources) {
  for ($i = 0; $i -lt $HostsListName.Count; $i++) {
    if ($HostsListName[$i] -eq $s) {
      Donwload-And-Filter-Hosts $HostsListURL[$i] $s
      Break
    }
  }
}

if ($script:Domains.Count -lt 1) {
  Write-Host "Something went wrong with downloading!"
  Exit
}

for ($i = 0; $i -lt $script:Domains.Count; $i++) {
  if ($script:Domains[$i].Trim() -eq "") {
    $script:Domains.RemoveAt($i)
    $i--
  } else {
    $script:Domains[$i] = $script:Domains[$i].Trim()
  }
}

foreach ($currentDomain in $script:RemoveDomains ) {
  $script:Domains.Remove($currentDomain)
}

$script:Domains = ($script:Domains | Sort-Object | Get-Unique)

<# MERGE HOST FILES #>

function Generate-Text-Info
{
  $Date = Get-Date
  $TextInfo = (-join ("# Simple hosts merge script by AQtun`n# https://github.com/AQtun81/HostsFileMerge`n# Generated: ", $Date, "`n# Used Sources:"))

  for ($i = 0; $i -lt $script:SourcesURL.Count; $i++) {
    $TextInfo += (-join ("`n# ", $script:SourcesURL[$i]))
  }

  return $TextInfo
}

function Append-Removed
{
  return "`n127.0.0.1 localhost`n127.0.0.1 localhost.localdomain`n127.0.0.1 local`n255.255.255.255 broadcasthost`n::1 localhost`n::1 ip6-localhost`n::1 ip6-loopback`nfe80::1%lo0 localhost`nff00::0 ip6-localnet`nff00::0 ip6-mcastprefix`nff02::1 ip6-allnodes`nff02::2 ip6-allrouters`nff02::3 ip6-allhosts`n0.0.0.0 0.0.0.0"
}

Write-Host "------------------------"
Write-Host "Merging final hosts file"

[string]$Result = ""
$Result += (Generate-Text-Info)
$Result += (Append-Removed)

[System.Collections.ArrayList]$script:DomainsAliased = @()

for ($i = 0; $i -lt $script:Domains.Count; $i += $Aliases) {
  $script:DomainsAliased += $script:Domains[$i..($i + $Aliases - 1)] -join " "
}

$script:DomainsAliased = ($script:DomainsAliased -Replace '^', (-join ("`n", $IPFormat, ' ')))

$Result += $script:DomainsAliased

if ($Install) {
  Set-Location (-join ($env:systemroot, "\System32\drivers\etc"))
  $Result | Set-Content hosts
} else {
  $Result | Set-Content hosts
}

#endregion