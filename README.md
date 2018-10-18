# Term9 (WIP)

Plan9/acme like interaction for the Linux terminal.

## Currently Working
All actions are triggered by selecting something on the terminal and right clicking. This is referred to as 'selection' hereafter.

1. Open pdfs, images, html (in the browser) in the background.
2. In bash, if the last command starts with `ls`, selecting a directory changes into the dir, otherwise opens file in vi.

## Setting up the pieces

### Terminal Emulator
1. Enable plumbing on right click selection. Needs to call external script. (Done with st. Patch included.).

### Shell
2. Enable saving of shell contents to some known file. using `script` for now. (Shell needs to call script on boot, .bashrc included.)

### X11/Windowing system
Currenly uses xdotool.

### Plumbing
Currently a script called on selection from the terminal that reads the shell contents, uses the context to take some action automatically. Analyzes context of the selection independently and picks one of the available actions.

## Larger goals
1. Context specific action taken on output of past commands in the shell. For example, if the last command were `git branch`, selecting a branch name should checkout the branch. This will all be case based.
2. Larger interop between the window system (like the window manager), the terminal emulator, the actual program running in the terminal (bash, vi, other programs...). This includes stuff like opening a new file as a new buffer in an existing vim instance rather than starting vim again.
3. Acme like menu bar (the likes of dmenu) that can be embedded into any application and would support editable menus.

## Limitations
1. The system will be hacky, we are looking at maximally non-invasive changes (to all softwares involved) to support a wide range of applications and *complete* backward compatibility. This means, we will at best have heuristics, not deterministic solutions.
