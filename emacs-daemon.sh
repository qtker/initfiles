#!/bin/sh

if emacsclient -t "$@"; then
    :
else
    /usr/local/bin/emacs --daemon
    exec emacsclient -t "$@"
fi
