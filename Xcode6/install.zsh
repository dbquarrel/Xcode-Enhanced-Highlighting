#!/usr/bin/env zsh

SAY(){ printf "\033[1;31m%-28b\033[0m" "$1" && shift && printf "%s\n" "$@" }

SAY '\nXcode is:' "${XC=${$('xcode-select' -p)%.app/*}.app}"
SAY 'This dir is:' "${HERE=${0:h}}"
SAY 'WIll copy to:' "${DEST=$XC/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources}"
SAY 'Backup to (if needed):' "${BACKUP=${0:h}/Backup}"

ps aux | grep '[X]code' 1> /dev/null && { 
  
  read REPLY\?"OK to quit xcode? [y/N] " 
  [[ "$REPLY" =~ ^([Yy])$ ]] || { echo "cowers in fear.  exiting"; exit 1 }
  killall Xcode || killall "Xcode-Beta"
}

SPECS=( $HERE/*.(xclangspec|xcsynspec) ); SAY '\nTo copy (as sudo) are:\n' "${SPECS[@]}"

read REPLY\?"That OK? [y/N] "

[[ "$REPLY" =~ ^([Yy])$ ]] && { 
  
  for x in $SPECS; { 
  [[ -f "$DEST/${x:t}" ]] && ! diff "$x" "$DEST/${x:t}" \
                          && { mkdir -p "$BACKUP" && cp -v "$DEST/${x:t}" "$BACKUP" && SAY 'Backed up' "${x:t}" }
  sudo cp -vf "$x" "$DEST" && echo 
}

} || echo "Skipping Copy" && echo "Working..."

PURGE=( $(find "$XC/Contents/OtherFrameworks" | egrep 'ObjectiveC\+{0,2}?\.xclangspec$') )

SAY 'Found these meddlesome files:\n\n' "${PURGE[@]}"

read REPLY\?"Want to purge (backup) these? [y/N] "

[[ "$REPLY" =~ ^([Yy])$ ]] && {  

  SUBBACKUP="$BACKUP/XCODEAPP/Contents/OtherFrameworks" 
  for x in "${PURGE[@]}"; { 

    mkdir -p "${BAKDEST=$SUBBACKUP/${${x#*OtherFrameworks/}:h}}"
    # SAY "moving $x to\n" "$BAKDEST"
    sudo mv -fv "$x" "$BAKDEST"
  } 
  
} || echo "SKipping Purge" && echo "\nWorking..."

CACHE=( $(find /private/var/folders -name \*Xcode\* -print 2> /dev/null) )

read REPLY\?"Want to delete the ${#CACHE} cache files found in /private/var/folders? [y/N] "

[[ "$REPLY" =~ ^([Yy])$ ]] && { rm -rf "${CACHE[@]}" }

mkdir -p "${THEMEFOLDER=$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/}"
cp -fv "$HERE/*.dvtcolortheme" "$THEMEFOLDER"
