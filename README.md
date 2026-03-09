# apk-upgrade

![Shell](https://img.shields.io/badge/shell-POSIX-blue)
![OpenWrt](https://img.shields.io/badge/OpenWrt-25.x-green)
![License](https://img.shields.io/github/license/kongvut/apk-upgrade)

List and upgrade **OpenWrt packages using APK (Alpine Package Keeper)**.

A small **POSIX shell / ash utility** that makes it easier to check and upgrade packages on **OpenWrt 25.12+**, where the package manager has changed from **opkg → apk**.

Inspired by the original `opkg-upgrade` script but refactored for modern OpenWrt.

---

# Why this project exists

Starting with **OpenWrt 25.x**, the project began transitioning from **opkg** to **apk (Alpine Package Keeper)**.

Because of this change many existing scripts relying on:

```
opkg update
opkg list-upgradable
opkg install
```

no longer work.

This script provides a **simple replacement** for those workflows using:

```
apk update
apk version -l '<'
apk upgrade
```

---

# Features

* Designed for **OpenWrt 25.12+**
* Lightweight **POSIX shell script**
* No external dependencies
* Clean table output
* Interactive upgrade confirmation
* Works with **cron / automation**
* Safe default behavior

---

# Example output

```
root@N100:~# ./apk-upgrade.sh

=====================================
OpenWrt APK Upgrade Utility v1.2
Router : N100
Time   : 2026/03/10 02:41:21
=====================================
Updating package index...

#    Package                             Current              Available
---- ----------------------------------- -------------------- --------------------
1    luci                                26.065.64115~7893658 26.067.64894~7e202d6
2    luci-app-attendedsysupgrade         26.065.64115~7893658 26.067.64894~7e202d6
3    luci-app-ddns                       26.065.64115~7893658 26.067.64894~7e202d6
4    luci-app-firewall                   26.065.64115~7893658 26.067.64894~7e202d6
5    luci-app-irqbalance                 26.065.64115~7893658 26.067.64894~7e202d6
6    luci-app-mwan3                      26.065.64115~7893658 26.067.64894~7e202d6
7    luci-app-nlbwmon                    26.065.64115~7893658 26.067.64894~7e202d6
8    luci-app-package-manager            26.065.64115~7893658 26.067.64894~7e202d6
9    luci-app-sqm                        26.065.64115~7893658 26.067.64894~7e202d6
10   luci-app-statistics                 26.065.64115~7893658 26.067.64894~7e202d6
11   luci-app-ttyd                       26.065.64115~7893658 26.067.64894~7e202d6
12   luci-app-uhttpd                     26.065.64115~7893658 26.067.64894~7e202d6
13   luci-base                           26.065.64115~7893658 26.067.64894~7e202d6
14   luci-compat                         26.065.64115~7893658 26.067.64894~7e202d6
15   luci-lib-base                       26.065.64115~7893658 26.067.64894~7e202d6
16   luci-lib-chartjs                    26.065.64115~7893658 26.067.64894~7e202d6
17   luci-lib-ip                         26.065.64115~7893658 26.067.64894~7e202d6
18   luci-lib-ipkg                       26.065.64115~7893658 26.067.64894~7e202d6
19   luci-lib-jsonc                      26.065.64115~7893658 26.067.64894~7e202d6
20   luci-lib-nixio                      26.065.64115~7893658 26.067.64894~7e202d6
21   luci-lib-uqr                        26.065.64115~7893658 26.067.64894~7e202d6
22   luci-light                          26.065.64115~7893658 26.067.64894~7e202d6
23   luci-lua-runtime                    26.065.64115~7893658 26.067.64894~7e202d6
24   luci-mod-admin-full                 26.065.64115~7893658 26.067.64894~7e202d6
25   luci-mod-network                    26.065.64115~7893658 26.067.64894~7e202d6
26   luci-mod-status                     26.065.64115~7893658 26.067.64894~7e202d6
27   luci-mod-system                     26.065.64115~7893658 26.067.64894~7e202d6
28   luci-proto-ipv6                     26.065.64115~7893658 26.067.64894~7e202d6
29   luci-proto-ppp                      26.065.64115~7893658 26.067.64894~7e202d6
30   luci-proto-wireguard                26.065.64115~7893658 26.067.64894~7e202d6
31   luci-ssl                            26.065.64115~7893658 26.067.64894~7e202d6
32   luci-theme-bootstrap                26.065.64115~7893658 26.067.64894~7e202d6

Total packages: 32

Proceed with upgrade? (y/N):
```

---

# Usage

```
apk-upgrade [options]
```

## Options

```
-h, --help        Show help
-c, --check       Exit with code 0 if upgrades are available
-l, --list        List available upgrades only
-f, --force       Skip confirmation prompt
-n, --no-update   Skip repository update (apk update)
-q, --quiet       Quiet mode
```

---

# Examples

Check if updates exist (useful for monitoring scripts):

```
apk-upgrade --check
```

List upgrades:

```
apk-upgrade --list
```

Upgrade packages without confirmation:

```
apk-upgrade --force
```

---

# Installation

## Clone repository

```
wget https://raw.githubusercontent.com/kongvut/apk-upgrade/main/apk-upgrade.sh
chmod +x apk-upgrade.sh
```

Run directly:

```
./apk-upgrade.sh
```

---

## System install

Install globally to `/usr/sbin`:

```
cp apk-upgrade.sh /usr/sbin/apk-upgrade
chmod +x /usr/sbin/apk-upgrade
```

Run with:

```
apk-upgrade
```

---

# Quick run from internet

Download and run directly to `/tmp`:

### Using wget

```
wget https://raw.githubusercontent.com/kongvut/apk-upgrade/main/apk-upgrade.sh -O /tmp/apk-upgrade.sh \
&& chmod +x /tmp/apk-upgrade.sh \
&& /tmp/apk-upgrade.sh
```

### Using curl

```
curl -L https://raw.githubusercontent.com/kongvut/apk-upgrade/main/apk-upgrade.sh -o /tmp/apk-upgrade.sh \
&& chmod +x /tmp/apk-upgrade.sh \
&& /tmp/apk-upgrade.sh
```

---

# Automation (cron)

Run upgrade automatically every night:

```
0 3 * * * /usr/sbin/apk-upgrade --force
```

Only check for updates:

```
0 */6 * * * /usr/sbin/apk-upgrade --check
```

---

# Notes

* Always **check for configuration file conflicts** after upgrading packages.
* Ensure you have **enough free space on `/overlay`** before performing upgrades.
* On development snapshots, upgrading packages may occasionally break dependencies.

For production devices it is recommended to upgrade only on **stable OpenWrt releases**.

---

# Credits

Original idea from:

https://github.com/tavinus/opkg-upgrade

Refactored for modern OpenWrt using `apk`.

---

# License

MIT License
