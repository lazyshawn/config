#!/bin/bash
# @brief: link compile_commands.json in current dir to parent dir.

### Get absolute path of the current directory
# Ref: https://stackoverflow.com/a/1638397
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

PARENTPATH="$(dirname "$SCRIPTPATH")"
FNAME="/compile_commands.json"
CPLCMD="$SCRIPTPATH$FNAME"
OUTFILE="$PARENTPATH$FNAME"

### Check if compile_commands.json exists
# Ref: https://linuxize.com/post/bash-check-if-file-exists/
if test -f "$CPLCMD"; then
  echo "$CPLCMD"
  ln -s $CPLCMD $OUTFILE
else
  echo "ERROR: compile_commands.json does not exists."
fi

