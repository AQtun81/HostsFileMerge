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
If you want to use other than default sources then clone this sub-directory using instructions below, modify source file and run "MergeHostsLocal.bat".

## View source code

[View Source](https://github.com/AQtun81/aqtun81.github.io/blob/master/ps/hosts/MergeHosts.ps1)

## Downloads

[Batch file](https://raw.githubusercontent.com/AQtun81/aqtun81.github.io/master/ps/hosts/MergeHosts.bat)

## Cloning

This example will clone only this sub-directory<br/>
(requires git 2.19 or higher)
```
git clone --depth 1 --filter=blob:none --sparse https://github.com/AQtun81/aqtun81.github.io
cd aqtun81.github.io
git sparse-checkout set ps\hosts
```
