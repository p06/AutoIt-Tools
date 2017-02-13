# AutoIt-Tools
AutoIt scripts and stuff

## WatchClipBoard
### Starting the tool
Can be double-clicked (takes no arguments). May not be well suited for Windows auto-start, since user interaction will probably be required immediately.
### What it does
This tool will watch the system clipboard for new text contents. These will be pasted into an already-open "unsaved" notepad/editor window, and the user may opt to have the tool open such an editor instance if none is open at tool startup.
### &#x261E; Note:
if paused via its tray icon, the last newly copied text will still be processed once pausing is ended.
