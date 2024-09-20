#!/sbin/sh
#
# ADDOND_VERSION=2
#
# Waehrend eines System-Upgrades sichert dieses Skript
# die hinzugefuegten Systemanwendungen und stellt sie nach
# der Formatierung von /system wieder her.
#

. /tmp/backuptool.functions

list_files() {
cat <<EOF
product/media/bootanimation.zip
EOF
}

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Set permissions
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
    unmount_extras
    chmod 600 $SYS/build.prop
  ;;
esac
