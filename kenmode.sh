#!/bin/bash

# Name:         kenmode
# Description:  Bash productivity improver
# Version:      1.0.36
# Date:         2022-11-04
# Copyright:    Kenneth Aaron , flyingrhino AT orcon DOT net DOT nz
# License:      GPLv3
# Github:       https://github.com/flyingrhinonz/kenmode

#   Usage - source this file in your terminal:    . kenmode.sh
#       and enjoy better productivity.
#
#   Especially useful if you want to keep the existing system look and feel
#       untouched for other users who share the same login - if you don't
#       care about this - you may decide to merge these settings into your
#       .bashrc file and they will be loaded automatically when you login.
#       Or simply call this file at the end of your .bashrc  .
#
#   This also sets up more productive vim when the appropriate vim
#       settings are present. For more details on improving vim check my page here:
#       https://github.com/flyingrhinonz/vimrc_linux
#
#   If you wish to remove any of the added commands from an already-running shell
#       (such as:  ll, lll, jcff, etc...) - they are defined as functions (not aliases).
#   View them with:  set
#   Remove them with:  unset -f <function_name>
#       Note - without:  -f  bash will try to remove a variable with the same name
#       first, and if not found will try to remove the function.


if ! [[ $- == *i* ]]; then
    return
        # ^ If this is a non-interactive terminal do not proceed.
fi


export MYCUSTOMVIM="ken"
    # ^ Sets up vim kenmode for vim configs that support it. Otherwise vim is left untouched.
    #       You need the supporting changes in vim config files for this to work.

export LESS="-# 12 MRdXSKI"
    # ^ More sensible horizontal scrolling offset in less pager.
    #   Note - this may cause compatibility issues with programs that use the pager
    #       and force their own commands (for example git).
    #   The:  -F  flag causes problems if you really want to pipe stuff through less
    #       and it is less than one page long. That's why it's not in the args here.
    #
    #   Args explained:
    #       -# 12   Horizontal scrolling is now 12 chars instead of the default half screen
    #       M       More verbose prompt
    #       R       Raw contol chars can be displayed - good for ansi color
    #       d       Suppress the dumb terminal error message
    #       F       Quit if output can fit into one screen
    #       X       Disable termcap  initialization and deinitialization strings to the terminal
    #       S       Long lines are not wrapped - you can view them with left/right arrows
    #       K       Quits less when ctrl-c is pressed
    #       I       Searches ignore case even if the pattern contains uppercase letters.

export SYSTEMD_LESS="MRdFXSKI # 12"
    # ^ More sensible paging for journalctl

#export GIT_PAGER="cat"
    # ^ Prevents git from causing problems with my "export LESS=..." setup.
    #       This will allow me to use my own pager if I wish to do so.
    #       I'm not using this because git gets along ok with my current LESS export settings.

export MYCUSTOMTMUX_KEN="ken"
    # ^ Imports additional tmux settings from:  /etc/tmux.conf.ken  when
    #       my custom:  /etc/tmux.conf  finds this env var set.


# If vim exists, setup vim as preferred editor:
if [[ -x /usr/bin/vim ]]; then
    export VISUAL="/usr/bin/vim"
    export EDITOR="/usr/bin/vim"
        # ^ Force editor to be vim rather than whatever default a program uses.
        #   Different programs check different vars - so I'm setting both.

    alias view='/usr/bin/vim -M'
        # ^ Useful because in RH:  view  calls:  vi  and not:  vim
        #   Also arg:  -M  makes vim truly readonly, as opposed to:  -R  that warns
        #       about changes but let you force a write anyway.
fi


# Improve history:
export HISTCONTROL=ignoredups
    # ^ Line after line command duplicates are not saved.
export HISTFILESIZE=4000
export HISTSIZE=4000
    # ^ Increase history in memory and persistently.
export HISTTIMEFORMAT="%F %T  "
    # ^ Gives proper timestamps on history commands.

set -o vi
    # ^ Make command line use vim editing key bindings

unalias l &> /dev/null || :
    # ^ Remove system alias because I don't need it (this exists in linux mint and maybe other distros)
unalias ll &> /dev/null || :
    # ^ Remove system alias because I have a better one...
unalias lll &> /dev/null || :
    # ^ Remove system alias because I have a better one...


# Much better 'ls' versions:
function ll     { ls -lsbF --color=always --time-style=long-iso "$@" | less -MRdFXSKI; }
function llh    { ls -lsbFh --color=always --time-style=long-iso "$@" | less -MRdFXSKI; }
function lll    { ls -lasbF --color=always --time-style=long-iso "$@" | less -MRdFXSKI; }
    #   ^ Notes:
    #
    #   ll  Displays regular files. This is the base command. Add to it the following letters:
    #   +l  Shows hidden files too.
    #   +h  Displays human readable file sizes.
    #   +z  Shows selinux label.
    #
    #   You can add your own args on the command line which will be passed to:  ls .
    #
    #   Be aware that:  column  expands on whitespace - if you have any spaces in your filenames
    #       or anywhere else - they will be columnized in the output. You can spot these
    #       when you see the backslashes and whitespace after. The output is still easier to read
    #       than without column so this is the lesser evil.
    #   Normally in our kind of output whitespace is found only in filenames (if at all)
    #       and you're using 'z' for selinux contexts - so your columns will most likely be fine
    #       and only skewed in the last column which holds the file name.
    #   If you find a simple solution please tell me.


#function llz    { ls -ZlbF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI; }
#function lllz   { ls -ZlabF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI; }
    # ^ The function definitions later on use native `ls` features and should be better.
    #
    #   Note: Newer versions of:  ls  (as in RHEL 8+ and other new distros) display
    #       selinux column width properly but some people still like my version of:  llz  that uses
    #       'column -t'  with a double space - it makes the output more readable so I'm keeping
    #       this version here too in case you want to use it.
    #       Remember to comment out:  llz  and:  lllz  functions below.
    #
    #   Note: I added the cut filter to solve this message sometimes received
    #       in selinux 'Z' operations:  'column: line too long' .


function llz {
    # ^ There can be issues with:  column causing trouble:
    #       a. It sometimes doesn't handle colored text and misinterprets color codes.
    #       b. Whitespace in text fields is interpreted as individual colums - skewing the output.
    #   Newer versions of:  ls  display selinux width properly and this function checks for
    #       a suitable version of:  ls  to use it instead of:  column.
    #   For human readable - just do:  llz -h  (you can add any args you want).
    local LsVersion="$(ls --version | head -n 1)"
    local CleanLsVersion="${LsVersion##* }"
    local MajorVersion="${CleanLsVersion%%.*}"
    local MinorVersion="${CleanLsVersion##*.}"

    if (( $MajorVersion >= 8 )); then
        if (( $MinorVersion >= 30 )); then
            ls -ZlbF --color=always --time-style=long-iso "$@" | less -MRdFXSKI
            return
        fi
    fi

    ls -ZlbF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI
}


function lllz {
    # ^ Same comment as function:  llz
    local LsVersion="$(ls --version | head -n 1)"
    local CleanLsVersion="${LsVersion##* }"
    local MajorVersion="${CleanLsVersion%%.*}"
    local MinorVersion="${CleanLsVersion##*.}"

    if (( $MajorVersion >= 8 )); then
        if (( $MinorVersion >= 30 )); then
            ls -ZlabF --color=always --time-style=long-iso "$@" | less -MRdFXSKI
            return
        fi
    fi

    ls -ZlabF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI
}


function kenps { ps auxfww | less; }
    # ^ Useful version of ps command.


function kengrep  { grep --color=always "$@"; }
    # ^ Forces colored grep always (by default grep removes colorization when
    #       it detects it's fed into a pipe.
    #   Don't use this command in scripts - it can break the rest of your pipeline
    #       because it adds extra chars (color codes) to your text.


function kendu    { du -smx * .[^.]* 2>/dev/null | sort -Vr | less -MRdFXSKI; }
    # ^ More usable du (better still - use:  ncdu  if you can) .
    #       Gives output in Mbytes, sorted by size descending.
    #       Only works in current dir - ignores all args supplied to it.
    #       Does not scan different file systems (du -x).
    #   The second part of du looks for hidden files/dirs.


function jcff   { journalctl --follow --lines=0 --all --output=short-iso --pager-end --no-pager "$@"; }
    # ^ Usability improvements for tailing journalctl - Follow Full line length
    #   Tip - use arg:  -t <syslog_identifier>  for further filtering. Eg:  jcff -t crond
    #       Multiple:  -t  can be used which match any of the items supplied.


function jcft   { journalctl --follow --lines=0 --no-full --output=short-iso --pager-end --no-pager "$@"; }
    # ^ Usability improvements for tailing journalctl - Follow Truncate to window width


# Make the command prompts more usable:
#   Documented here: https://phoenixnap.com/kb/change-bash-prompt-linux
if (( $EUID == 0 )); then
    PS1='\[\033[00;33m\]\D{%Y-%m-%d %H:%M:%S} \[\033[01;31m\]\u@\h \[\033[01;34m\]${PWD%%\/}/ \$\[\033[00m\] '
        # ^ For root user
else
    PS1='\[\033[00;33m\]\D{%Y-%m-%d %H:%M:%S} \[\033[01;32m\]\u@\h \[\033[01;34m\]${PWD%%\/}/ \$\[\033[00m\] '
        # ^ For non-root users
fi


# List outstanding items:
if [[ -s ~/todo.txt ]]; then
    echo
    echo "***** There are outstanding tasks. Printing:  ~/todo.txt: *****"
    cat ~/todo.txt
fi


# List terminal multiplexers running sessions:

# Handle tmux:
#if [[ (-v PS1) && ( -x /usr/bin/tmux ) ]]; then
    # ^ This works in bash 4.2+ but some boxes run older bash
    #       so we need to use the less powerful solution below:

if [[ ( PS1 ) && ( -x /usr/bin/tmux ) ]]; then
    TmuxResult="$( /usr/bin/tmux ls 2>/dev/null || echo "NONE" )" || :

    if [[ "${TmuxResult}" == "NONE" ]]; then
        #echo
        #echo "*** No running TMUX sessions found ***"
            # ^ Unnecessary output
        :   # Required when clause is empty
    else
        echo
        echo "***** Currently running TMUX sessions: *****"
        echo "${TmuxResult}"
    fi
fi


# Handle screen:
#if [[ ( -v PS1 ) && ( -x /usr/bin/screen ) ]]; then
    # ^ This works in bash 4.2+ but some boxes run older bash
    #       so we need to use the less powerful solution below:

if [[ (  PS1 ) && ( -x /usr/bin/screen ) ]]; then
    ScreenResult="$( /usr/bin/screen -ls 2>&1 || : )" || :

    if [[ ( "${ScreenResult}" == *"There are screens on"* ) || ( "${ScreenResult}" == *"There is a screen on"* )  ]]; then
        echo
        echo "***** Currently running SCREEN sessions: *****"
        echo "${ScreenResult}"
    else
        #echo
        #echo "*** No running SCREEN sessions found ***"
            # ^ Unnecessary output
        :   # Required when clause is empty
    fi
fi


echo


