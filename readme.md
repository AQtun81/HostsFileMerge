# Hosts file merge script

![](/img/GUI.png)

Powershell script that automatically downloads and merges multiple hosts files.<br/>
<br/>
By default 3 sources are used:<br/>

| source                                                                | direct link                                                                                           |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [adaway.org](https://adaway.org/)                                     | [link](https://adaway.org/hosts.txt)                                                                  |
| [github.com/StevenBlack/hosts](https://github.com/StevenBlack/hosts)  | [link](https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts)                              |
| [winhelp2002.mvps.org](https://winhelp2002.mvps.org/)                 | [link](https://winhelp2002.mvps.org/hosts.txt)                                                        |

<br/>
Other sources that can be selected:<br/>

| source                                                                | direct link                                                                                           |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [pgl.yoyo.org/adservers](https://pgl.yoyo.org/adservers)              | [link](https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext) |
| [sysctl.org/cameleon](https://sysctl.org/cameleon)                    | [link](https://sysctl.org/cameleon/hosts)                                                             |
| [someonewhocares.org/hosts](https://someonewhocares.org/hosts)        | [link](https://someonewhocares.org/hosts/hosts)                                                       |
| [malwaredomainlist.com](https://www.malwaredomainlist.com)            | [link](https://www.malwaredomainlist.com/hostslist/hosts.txt)                                         |
| [hostsfile.org](https://www.hostsfile.org)                            | [link](https://www.hostsfile.org/Downloads/hosts.txt)                                                 |
| [lewisje.github.io](http://lewisje.github.io)                         | [link](https://raw.githubusercontent.com/lewisje/jansal/master/adblock/hosts)                         |
| [github.com/yous/YousList](https://github.com/yous/YousList)          | [link](https://raw.githubusercontent.com/yous/YousList/master/hosts.txt)                              |

## Usage

### GUI mode

"Replace Hosts file on this machine" requires administrator privilages,<br/>
the script will ask for permissions before installing.

### CLI mode

| argument                | type                    |
| ----------------------- | ----------------------- |
| `Install`               | bool                    |
| `Sources`               | string array            |
| `IPFormat`              | string                  |
| `Aliases`               | integer                 |

"Copy Command" button will create command with arguments matching selection in window.

## View source code

[View Source](https://github.com/AQtun81/HostsFileMerge/blob/main/MergeHosts.ps1)

## Downloads

[Batch file](https://aqtun81.github.io/HostsFileMerge/MergeHosts.bat)