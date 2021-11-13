#!/bin/bash

#   Written by Kenneth Aaron , v1.0.21 , 2021-11-14
#
#   Usage - source this file in your terminal:    . kenmode.sh
#       and enjoy better productivity.
#
#   Especially useful if you want to keep the existing system look and feel
#       untouched for other users who share the same login - if you don't
#       care about this - you may decide to merge these settings into your
#       .bashrc file and they will be loaded automatically when you login.
#       Or simply call this file at the end of your .bashrc
#
#   This also sets up more productive vim when the appropriate vim settings
#       are present. For more details on improving vim check my page here:
#       https://github.com/flyingrhinonz/vimrc_linux
#
#   If you wish to remove any of the added commands from an already-running shell
#       (such as:  ll, lll, jcff, etc...) - they are defined as functions (not aliases).
#   View them with:  set
#   Remove them with:  unset -f <function_name>
#       Note - without:  -f  bash will try to remove a variable with the same name
#       first, and if not found will try to remove the function.


export MYCUSTOMVIM="ken"
    # ^ Sets up vim kenmode for vim configs that support it. Otherwise vim is left untouched.
    #       You need the supporting changes in vim config files for this to work.

export LESS="-# 8 MRdXSKI"
    # ^ More sensible horizontal scrolling offset in less pager.
    #   Note - this may cause compatibility issues with programs that use the pager
    #       and force their own commands (for example git).
    #   The:  -F  flag causes problems if you really want to pipe stuff through less
    #       and it is less than one page long. That's why it's not in the args here.
    #
    #   Args explained:
    #       -# 8    Horizontal scrolling is now 8 chars instead of the default half screen
    #       M       More verbose prompt
    #       R       Raw contol chars can be displayed - good for ansi color
    #       d       Suppress the dumb terminal error message
    #       F       Quit if output can fit into one screen
    #       X       Disable termcap  initialization and deinitialization strings to the terminal
    #       S       Long lines are not wrapped - you can view them with left/right arrows
    #       K       Quits less when ctrl-c is pressed
    #       I       Searches ignore case even if the pattern contains uppercase letters.

export SYSTEMD_LESS="MRdFXSKI # 8"
    # ^ More sensible paging for journalctl

#export GIT_PAGER="cat"
    # ^ Prevents git from causing problems with my "export LESS=..." setup.
    #       This will allow me to use my own pager if I wish to do so.
    #       I'm not using this because git gets along ok with my current LESS export settings.


# If vim exists, setup vim as preferred editor:
[[ -x /usr/bin/vim ]] && \
    {
    export VISUAL="/usr/bin/vim"
    export EDITOR="/usr/bin/vim"
        # ^ Force editor to be vim rather than whatever default a program uses.
        #   Different programs check different vars - so I'm setting both.

    alias view='/usr/bin/vim -R'
        # ^ Useful because in RH 'view' calls 'vi' and not 'vim'
    }


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
function llz    { ls -ZlbF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI; }
function lll    { ls -lasbF --color=always --time-style=long-iso "$@" | less -MRdFXSKI; }
function lllz   { ls -ZlabF --color=always --time-style=long-iso "$@" | cut -c-2048 | column -t | less -MRdFXSKI; }
    # ^ Notes:
    #
    # ll    Displays regular files, lll shows hidden ones too.
    # h     Displays human readable file sizes.
    # z     Adds support for selinux.
    #
    # Be aware that column expands on whitespace - if you have any spaces in your filenames
    #   or anywhere else - they will be columnized in the output. You can spot these
    #   when you see the backslashes and whitespace after.
    #   This is only done for selinux 'z functions' and the output is still easier to read
    #   than without column so this is the lesser evil.
    #   Normally in our kind of output whitespace is found only in filenames (if at all)
    #   and you're using 'z' for selinux contexts - so your columns will most likely be fine
    #   and only skewed in the last column which holds the file name.
    #   If you find a simple solution please tell me.
    #
    # I added the cut filter to solve this message sometimes received
    #   in selinux 'Z' operations:  'column: line too long' .
    #
    # You can add your own args on the command line which will be passed to 'ls' .


function kdu    { du -smx * | sort -Vr | less -MRdFXSKI; }
    # ^ More usable du (better still - use 'ncdu' if you can) .
    #       Gives output in Mbytes, sorted by size descending.
    #       Only works in current dir - ignores all args supplied to it.


function jcff   { journalctl --follow --lines=0 --all --output=short-iso --pager-end --no-pager "$@"; }
    # ^ Usability improvements for tailing journalctl - Follow Full line length
    #   Tip - use arg:  -t <syslog_identifier>  for further filtering. Eg:  jcff -t crond


function jcft   { journalctl --follow --lines=0 --no-full --output=short-iso --pager-end --no-pager "$@"; }
    # ^ Usability improvements for tailing journalctl - Follow Truncate to window width


# Make the command prompts more usable:
(( $EUID == 0 )) && \
    {
    #PS1='\[\033[01;31m\]\u@\h \[\033[01;33m\]\D{%Y-%m-%d %H:%M:%S}\[\033[01;34m\] $PWD/ \$\[\033[00m\] '
    PS1='\[\033[01;31m\]\u@\h \[\033[01;33m\]\D{%Y-%m-%d %H:%M:%S}\[\033[01;34m\] ${PWD%%\/}/ \$\[\033[00m\] '
        # ^ For root user
    } || {
    #PS1='\[\033[01;32m\]\u@\h \[\033[01;31m\]\D{%Y-%m-%d %H:%M:%S}\[\033[01;34m\] $PWD/ \$\[\033[00m\] '
    PS1='\[\033[01;32m\]\u@\h \[\033[01;31m\]\D{%Y-%m-%d %H:%M:%S}\[\033[01;34m\] ${PWD%%\/}/ \$\[\033[00m\] '
        # ^ For non-root users
    }


# List outstanding items:
[[ -s ~/todo.txt ]] && \
    {
    echo
    echo "***** There are outstanding tasks. Printing:  ~/todo.txt: *****"
    cat ~/todo.txt
    } || {
    :
    }


# List terminal multiplexers running sessions:

# Handle tmux:
#[[ (-v PS1) && ( -x /usr/bin/tmux ) ]] && \
    # ^ This works in bash 4.2+ but some boxes run older bash
    #       so we need to use the less powerful solution below:

[[ ( PS1 ) && ( -x /usr/bin/tmux ) ]] && \
    {
    TmuxResult="$( /usr/bin/tmux ls 2>/dev/null || echo "NONE" )" || :
    [[ "${TmuxResult}" == "NONE" ]] && \
        {
        #echo
        #echo "*** No running TMUX sessions found ***"
            # ^ Unnecessary output
        :   # Required when clause is empty
        } || {
        echo
        echo "***** Currently running TMUX sessions: *****"
        echo "${TmuxResult}"
        }
    } || {
    :
    }


# Handle screen:
#[[ ( -v PS1 ) && ( -x /usr/bin/screen ) ]] && \
    # ^ This works in bash 4.2+ but some boxes run older bash
    #       so we need to use the less powerful solution below:

[[ (  PS1 ) && ( -x /usr/bin/screen ) ]] && \
    {
    ScreenResult="$( /usr/bin/screen -ls 2>&1 || : )" || :
    [[ ( "${ScreenResult}" == *"There are screens on"* ) || ( "${ScreenResult}" == *"There is a screen on"* )  ]] && \
        {
        echo
        echo "***** Currently running SCREEN sessions: *****"
        echo "${ScreenResult}"
        } || {
        #echo
        #echo "*** No running SCREEN sessions found ***"
            # ^ Unnecessary output
        :   # Required when clause is empty
        }
    } || {
    :
    }


echo


