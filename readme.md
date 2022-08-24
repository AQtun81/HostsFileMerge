# Hosts file merge script

Powershell script that automatically downloads and merges multiple hosts files.<br/>
<br/>
By default 4 sources are used:<br/>
| source                                                               | direct link                                                                                           |
|----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| [adaway.org](https://adaway.org/)                                    | [link](https://adaway.org/hosts.txt)                                                                  |
| [github.com/StevenBlack/hosts](https://github.com/StevenBlack/hosts) | [link](https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts)                              |
| [pgl.yoyo.org/adservers](https://pgl.yoyo.org/adservers)             | [link](https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext) |
| [winhelp2002.mvps.org](https://winhelp2002.mvps.org/)                | [link](https://winhelp2002.mvps.org/hosts.txt)                                                        |
<br/>
If you want to use other than default sources then clone this repository, modify source file and run "MergeHostsLocal.bat".

## View source code

[View Source](https://github.com/AQtun81/HostsFileMerge/blob/main/MergeHosts.ps1)

## Downloads

[Batch file](https://aqtun81.github.io/HostsFileMerge/MergeHosts.bat)