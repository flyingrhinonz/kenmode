# kenmode - improved bash interactive mode productivity

Copyright (C) 2021 Kenneth Aaron.

flyingrhino AT orcon DOT net DOT nz

Freedom makes a better world: released under GNU GPLv3.

https://www.gnu.org/licenses/gpl-3.0.en.html

This software can be used by anyone at no cost, however, if you like using my software and can support - please donate money to a children's hospital of your choice.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation: GNU GPLv3. You must include this entire text with your distribution.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.


# Manual install instructions:

Copy: **kenmode.sh**   to your home directory.
To use it every time you open a shell - call it from the end of your:  **~/.bashrc**  file.
To manually use it (for example on a shared machine that you don't want to permanently improve for everyone who's not yet ready for this) - simply source it at the command line:  **. kenmode.sh**  and it will only improve your current session.


# Usage:

* Much better command prompt for regular users and root.
* Changes bash command line editing to vi mode. Trust me - once you get used to vi mode you'll never go back.
* Improves pager behavior.
* Sets up vim kenmode for those who use my improved vim settings which can be found here:
    https://github.com/flyingrhinonz/vimrc_linux
* Better  **ls**  functions:  ll, llh, llz, lll, lllz .
* Functions to improve regularly used journalctl and du commands:  jcff, jcft, kdu .
* Displays your **~/todo.txt** file if it exists at login.
* Displays running screen and tmux session IDs if they exist at login.


Enjoy...


