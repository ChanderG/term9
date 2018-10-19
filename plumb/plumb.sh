input="$@"

# root id
rootid=$(ps -o ppid= $PPID | tr -d [[:space:]])
# pre-accepted log name
termlog="$HOME/.term9/$rootid.log"
# bit hacky, but gets the inner most program's pid
progpid=$(pstree $rootid -p | head -n1 | awk -F"---" '{print $NF}' | grep -o "[0-9]*")

### For now only work with bash

## context clues - Sensors
# This part deals with extracting useful information.
#1. Assumes we are only interested in the last command. If we select something from 2 commands above, will not work.

bash_prefix="chanderg@debian:"
# last command
# there seems to be all sorts of problems with script's recording when non-input keys are pressed
bash_last_command="$(cat $termlog | sed 's,\x1B\[[0-9;]*[a-zA-Z],,g' | grep -F $bash_prefix | tail -n2 | head | awk '{$1=""; print $0}' | tr -d '\r\000-\011\013\014\016-\037')"
bash_last_command_main="$(echo $bash_last_command | awk '{print $1}')"

## Commands

handleLS () {
	# check if the input is a folder
	if [ -d /proc/$progpid/cwd/$input ]; then 
		xdotool type "cd $input"; xdotool key Return
	else
		xdotool type "vi $input"; xdotool key Return
	fi
}

openPdf () {
	mupdf "/proc/$progpid/cwd/$input"
}

openBrowser () {
	firefox57 "/proc/$progpid/cwd/$input"
}

openImage () {
	sxiv "/proc/$progpid/cwd/$input"
}

## Parsers - understanding commands and deciding action to be taken.
# following are matched in order; re-order as needed

# use regex to decide action
case "$input" in 
	*.pdf)
		openPdf ;;
	*.html)
		openBrowser ;;
	*.png|*.jpeg)
		openImage ;;
esac

# use the context to decide an action
# ls should probably be the default option as well
if [ "$bash_last_command_main" = "ls" ]; then
	handleLS
fi
