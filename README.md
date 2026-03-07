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
=====================================
 OpenWrt APK Upgrade Utility v1.0
 Router : OpenWrt
 Time   : 2026/03/07 13:44
=====================================

#    Package                        Current         Available
--   ------------------------------ --------------- ---------------
1    busybox                        1.36.1-r2       1.36.1-r5
2    openssl                        3.1.4-r0        3.1.5-r0

Total packages: 2

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
git clone https://github.com/kongvut/apk-upgrade.git
cd apk-upgrade
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
