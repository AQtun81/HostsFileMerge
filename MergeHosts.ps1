[string[]]$Sources = @()
[System.Collections.ArrayList]$Domains = @()
$RemoveDomains = "localhost", "localhost.localdomain", "local", "broadcasthost", "localhost", "ip6-localhost", "ip6-loopback", "localhost", "ip6-localnet", "ip6-mcastprefix", "ip6-allnodes", "ip6-allrouters", "ip6-allhosts", "0.0.0.0"

<# USER CHOICES #>

Write-Host "Select blocking IP"
Write-Host "[0] Use 127.0.0.1"
Write-Host "[1] Use 0.0.0.0   (Better for Windows 8.1+) [Default]"
$IPChoice = Read-Host "Type value [0, 1]"
if ($IPChoice -eq 0) { # 127.0.0.1
  $IPChoice = "127.0.0.1"
} else { # 0.0.0.0
  $IPChoice = "0.0.0.0"
}
Write-Host (-join ("Using IP: ", $IPChoice))
Write-Host " "

Write-Host "Select alias limit"
Write-Host "[0] 9  (Windows) [Default]"
Write-Host "[1] 35 (Linux)"
Write-Host "[2] Don't use aliases"
$AliasChoice = Read-Host "Type value [0, 1, 2]"
if ($AliasChoice -eq 1) { # 35 (Linux)
  $AliasChoice = 35
} elseif ($AliasChoice -eq 2) { # Don't use aliases
  $AliasChoice = 1
} else { # 9  (Windows) (Default)
  $AliasChoice = 9
}
Write-Host (-join ("Using ", $AliasChoice, " Aliases Per IP Address"))
Write-Host " "

<# MAKE TEMP DIRECTORY FOR HOST FILES #>

if (-not (Test-Path ".\TMP-HOSTS\")) {
  New-Item -name "TMP-HOSTS" -type directory | Out-Null
}

<# DOWNLAOD HOSTS FILES #>

function Donwload-And-Filter-Hosts([string]$URL, [string]$FileName)
{
  Write-Host (-join ("Downloading Hosts File (", $FileName, ")"))
  Invoke-WebRequest -Uri $URL -OutFile (-join (".\TMP-HOSTS\", $FileName, "-hosts.txt"))

  Write-Host (-join ("Formatting Hosts File (", $FileName, ")"))
  (Get-Content (-join (".\TMP-HOSTS\", $FileName, "-hosts.txt")))  -Replace '[" "\t]*#.*', '' -Replace '.* ', '' | Where-Object { $_ -notmatch "^#" -and $_.trim() -ne "" } | Set-Content (-join (".\TMP-HOSTS\", $FileName, "-hosts-filtered.txt"))
  
  Write-Host (-join ("Loading Hosts File Into List (", $FileName, ")"))
  foreach ($currentDomain in Get-Content (-join (".\TMP-HOSTS\", $FileName, "-hosts-filtered.txt")) ) {
    $script:Domains.Add($currentDomain) | Out-Null
  }

  Write-Host " "
  $script:Sources += $URL
}

Donwload-And-Filter-Hosts "https://adaway.org/hosts.txt" "adaway"
Donwload-And-Filter-Hosts "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" "StevenBlack"
Donwload-And-Filter-Hosts "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" "Yoyos"
Donwload-And-Filter-Hosts "https://winhelp2002.mvps.org/hosts.txt" "MVP"

# Donwload-And-Filter-Hosts "https://sysctl.org/cameleon/hosts" "Cameleon"
# Donwload-And-Filter-Hosts "https://someonewhocares.org/hosts/hosts" "someonewhocares"
# Donwload-And-Filter-Hosts "https://www.malwaredomainlist.com/hostslist/hosts.txt" "malwaredomainlist"
# Donwload-And-Filter-Hosts "https://www.hostsfile.org/Downloads/hosts.txt" "hostsfileorg"
# Donwload-And-Filter-Hosts "https://raw.githubusercontent.com/lewisje/jansal/master/adblock/hosts" "jansal"
# Donwload-And-Filter-Hosts "https://logroid.github.io/blogger/file/hosts.txt" "logroid"
# Donwload-And-Filter-Hosts "https://raw.githubusercontent.com/eladkarako/hosts/master/build/hosts.txt" "eladkarako"
# Donwload-And-Filter-Hosts "https://raw.githubusercontent.com/yous/YousList/master/hosts.txt" "YousList"

<# FILTER DOMAIN LIST #>

$script:Domains = $script:Domains | Sort-Object | Get-Unique

foreach ($currentDomain in $script:RemoveDomains ) {
  $script:Domains.Remove($currentDomain)
}

<# MERGE HOST FILES #>

function Generate-Text-Info
{
  $Date = Get-Date
  $TextInfo = (-join ("# Simple hosts merge script by AQtun`n# https://github.com/AQtun81/aqtun81.github.io/blob/master/ps/hosts`n# Generated: ", $Date, "`n# Used Sources:"))

  for ($i = 0; $i -lt $script:Sources.Count; $i++) {
    $TextInfo += (-join ("`n# ", $script:Sources[$i]))
  }

  return $TextInfo
}

function Append-Removed
{
  return "127.0.0.1 localhost`n127.0.0.1 localhost.localdomain`n127.0.0.1 local`n255.255.255.255 broadcasthost`n::1 localhost`n::1 ip6-localhost`n::1 ip6-loopback`nfe80::1%lo0 localhost`nff00::0 ip6-localnet`nff00::0 ip6-mcastprefix`nff02::1 ip6-allnodes`nff02::2 ip6-allrouters`nff02::3 ip6-allhosts`n0.0.0.0 0.0.0.0"
}

Write-Host "------------------------"
Write-Host "Merging final hosts file"

if (Test-Path ".\hosts") {
  Remove-Item .\hosts -Force
}

Add-Content .\hosts (Generate-Text-Info)
Add-Content .\hosts (Append-Removed)

for ($i = 0; $i -lt $script:Domains.Count; $i += $AliasChoice) {
  $script:Domains[$i] = (-join ("`n", $script:Domains[$i]))
}

($script:Domains) -Replace '^', ' ' | Add-Content -NoNewline -Path ".\TMP-HOSTS\hosts-tmp"

((Get-Content ".\TMP-HOSTS\hosts-tmp") | Where-Object { $_.trim() -ne "" }) -Replace '^', (-join ($IPChoice, ' ')) | Add-Content -Path .\hosts

<# REMOVE TEMP DIRECTORY FOR HOST FILES #>

Remove-Item .\TMP-HOSTS -Recurse