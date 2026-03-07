#!/bin/sh
#################################################

# OpenWrt APK Upgrade Utility

# Compatible with OpenWrt 25.12+

#################################################

VERSION="1.0"
PKG_BIN="$(command -v apk 2>/dev/null)"

ROUTER_NAME="$(uname -n)"
TIMESTAMP="$(date '+%Y/%m/%d %H:%M:%S')"

QUIET=0
FORCE=0
JUST_CHECK=0
JUST_LIST=0
NO_UPDATE=0

PACKS=""
PACK_COUNT=0

############################################

# Helpers

############################################

die() {
echo "ERROR: $1" >&2
exit 1
}

msg() {
[ "$QUIET" -eq 1 ] && return
echo "$1"
}

############################################

# Checks

############################################

check_apk() {
[ -x "$PKG_BIN" ] || die "apk binary not found"
}

############################################

# Package operations

############################################

update_index() {
[ "$NO_UPDATE" -eq 1 ] && return
msg "Updating package index..."
"$PKG_BIN" update >/dev/null || die "apk update failed"
}

get_upgrades() {

```
PACKS="$($PKG_BIN version -l '<' | sort)"

if [ -n "$PACKS" ]; then
    PACK_COUNT=$(echo "$PACKS" | wc -l)
else
    PACK_COUNT=0
fi
```

}

############################################

# Output formatting

############################################

print_header() {

cat <<EOF

=====================================
OpenWrt APK Upgrade Utility v$VERSION
Router : $ROUTER_NAME
Time   : $TIMESTAMP
===================

EOF

}

print_table() {

[ "$PACK_COUNT" -eq 0 ] && {
echo "No packages to upgrade."
return
}

printf "%-4s %-30s %-15s %-15s\n" "#" "Package" "Current" "Available"
printf "%-4s %-30s %-15s %-15s\n" "--" "------------------------------" "---------------" "---------------"

i=1

echo "$PACKS" | while read line
do

pkg=$(echo "$line" | awk '{print $1}' | cut -d'-' -f1)
cur=$(echo "$line" | awk '{print $1}' | sed "s/$pkg-//")
new=$(echo "$line" | awk '{print $3}' | sed "s/$pkg-//")

printf "%-4s %-30s %-15s %-15s\n" "$i" "$pkg" "$cur" "$new"

i=$((i+1))

done

echo
echo "Total packages: $PACK_COUNT"

}

############################################

# Upgrade

############################################

confirm_upgrade() {

[ "$FORCE" -eq 1 ] && return 0

printf "\nProceed with upgrade? (y/N): "
read ans

case "$ans" in
y|Y) return 0 ;;
*) return 1 ;;
esac

}

run_upgrade() {

msg ""
msg "Starting upgrade..."
msg ""

"$PKG_BIN" upgrade || die "upgrade failed"

msg ""
msg "Upgrade finished."
msg ""

}

############################################

# CLI

############################################

usage() {

cat <<EOF

Usage: apk-upgrade [options]

Options:

-h --help       Show help
-c --check      Exit 0 if upgrades available
-l --list       List upgrades only
-f --force      Do not ask confirmation
-n --no-update  Skip 'apk update'
-q --quiet      Quiet mode

Examples:

apk-upgrade
apk-upgrade --list
apk-upgrade --check
apk-upgrade --force

EOF

exit 0

}

parse_cli() {

while [ $# -gt 0 ]; do

case "$1" in

-h|--help)
usage
;;

-c|--check)
JUST_CHECK=1
QUIET=1
;;

-l|--list)
JUST_LIST=1
;;

-f|--force)
FORCE=1
;;

-n|--no-update)
NO_UPDATE=1
;;

-q|--quiet)
QUIET=1
;;

*)
echo "Unknown option: $1"
usage
;;

esac

shift

done

}

############################################

# Main

############################################

main() {

parse_cli "$@"

check_apk

print_header

update_index

get_upgrades

if [ "$JUST_CHECK" -eq 1 ]; then

```
[ "$PACK_COUNT" -gt 0 ] && exit 0 || exit 1
```

fi

print_table

[ "$JUST_LIST" -eq 1 ] && exit 0

[ "$PACK_COUNT" -eq 0 ] && exit 0

confirm_upgrade || {
echo "Cancelled."
exit 1
}

run_upgrade

}

main "$@"
