# go-command

The `go` command aims to get directly to a survey directory only by the directory name – SN or Mac #, for example. 
The full path (/home/gmi/v2/…) doesn’t need to be specified. 
Saves some window switching and copying time.

Optimized for AMS FS! 
Works for all, but it takes some time for the non-default AMS directories, as it manually searches every dir in gmi/v2.

If the name is found in more than one of the default directories (e.g., in bor/v1/AG and lsr/bmr/v3) a prompt is shown to choose ti which path to go.

When a path is specified or if going to a temp-dir, `go` works as `cd`. So all cases below are valid:

    go 605158
  
    go /home/gmi/v2/gmi/v2/508119
  
    go temp-changes
  
    go ..


# Installation

Just copy the *go.sh* file content at the end of your **.bashrc** file. It’s in your home directory (/home/USER). 
*Ctrl+Alt+H* will display hidden files, in case **.bashrc** is not visible. 
On next login `go` will be usable.

