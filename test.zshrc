
matt.blissett.me.uk
Photos Contact
My .zshrc file

This is my .zshrc file.

# My .zshrc file
#
# Written by Matthew Blissett.
#
# Latest version available from https://matt.blissett.me.uk/linux/zsh/zshrc
#
# Some of this is my own creation, other functions are taken from various
# web sites or mailing lists, including:
# - http://leahneukirchen.org/dotfiles/.zshrc
#
# Last updated 2019-05-12
#
# Released into the public domain.
#

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Set prompt
# Exit status indicator in red (if not 0)
# Background job count in yellow (if not 0)
# Date in white, host in magenta, directory in default, prompt character
# Example:
#     1J 23:06:26 ig:~ >
PS1=$'%(?..%B%K{red}[%?]%K{def}%b )%(1j.%b%K{yel}%F{bla}%jJ%F{def}%K{def} .)%F{white}%B%*%b %F{mag}%m:%F{white}%~ %(!.#.>) %F{def}'
#     <------- exit status -------><------- background job count ----------><--- time ---->-< host ->-< cur dir >-<------> <----->
# (See 'EXPANSION OF PROMPT SEQUENCES' in zshmisc.)

# Completion system
autoload -Uz compinit
compinit

# Set less options
if [[ -x $(which less 2> /dev/null) ]]; then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    export LESSHISTFILE='-'
    if [[ -x $(which lesspipe 2> /dev/null) ]]; then
	LESSOPEN="| lesspipe %s"
	export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which emacs 2> /dev/null) ]]; then
    export EDITOR="emacs"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# FAQ 3.10: Why does zsh not work in an Emacs shell mode any more?
# http://zsh.sourceforge.net/FAQ/zshfaq03.html#l26
[[ $EMACS = t ]] && unsetopt zle

# Zsh settings for history
HISTORY_IGNORE="(ls|[bf]g|exit|reset|clear|cd|cd ..|cd..)"
HISTSIZE=25000
HISTFILE=~/.zsh_history
SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# nf [-NUM] [COMMENTARY...] -- never forget last N commands
nf() {
  local n=-1
  [[ "$1" = -<-> ]] && n=$1 && shift
  fc -lnt ": %Y-%m-%d %H:%M ${*/\%/%%} ;" $n | tee -a .neverforget
}

# imgur - post image to imgur.com
imgur() {
  curl -H "Authorization: Client-ID 3e7a4deb7ac67da" -F image=@$1 \
    https://api.imgur.com/3/upload | sed 's/.*http/http/; s/".*/\n/; s,\\/,/,g'
}


# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Colour output on Mac OS
export CLICOLOR=1

# Zsh spelling correction options
#setopt CORRECT
#setopt DVORAK

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Stop at / when deleting
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors 2> /dev/null` ]]; then
	eval `dircolors -b`
	alias 'ls=ls --color=auto'
    fi
fi

# Why is the date American even when the locale is en_GB?  Choose ISO form anyway.
export TIME_STYLE="long-iso"

# Commas in ls, du, df output
export BLOCK_SIZE="'1"

# No quoting spaces in newer coreutils
export QUOTING_STYLE=literal

# Short command aliases
alias 'l=ls'
alias 'la=ls -A'
alias 'll=ls -l'
alias 'llh=ls -l --si'
alias 'lq=ls -Q'
alias 'lr=ls -R'
alias 'lrs=ls -lrS'
alias 'lrt=ls -lrt'
alias 'lrta=ls -lrtA'
alias 'lrth=ls -lrth --si'
alias 'lrtha=ls -lrthA --si'
alias 'j=jobs -l'
alias 'kw=kwrite'
alias 'tf=tail -F'
alias 'grep=grep --colour --devices=skip'
alias 'vnice=nice -n 20 ionice -c 3'
alias 'get_iplayer=get_iplayer --nopurge'
alias 'get-iplayer=get-iplayer --nopurge'
alias "tree=tree -I 'CVS|.git|*~'"
alias 'lo=loffice'
alias 'synchist=fc -RI'

# Useful KDE integration
alias 'k=kate -u' # -u is reuse existing session if possible

# These are useful with the Dvorak keyboard layout
alias 'h=ls'
alias 'ha=la'
alias 'hh=ll'
alias 'hhh=llh'
alias 'hq=lq'
alias 'hr=lr'
alias 'hrt=lrt'
alias 'hrs=lrs'

# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# For Git
alias 'gk=z gitk --all'
alias 'gs=git status' # (NB overriding GhostScript)
alias 'gd=git diff'
alias 'gg=z git gui'
alias 'git-stashpullpop=git stash && git pull --rebase && git stash pop'
alias 'gl=git log --graph --abbrev-commit --pretty=oneline --decorate'

# For convenience
alias 'mkdir=mkdir -p'
alias 'cal=ncal -b' # Weeks start on Monday
alias 'dmesg=dmesg --ctime'
alias 'df=df --exclude-type=tmpfs --exclude-type=devtmpfs'
alias 'd.=df -h . |sed 1d'
alias 'dus=du -msc * .*(N) | sort -n'
alias 'dus.=du -msc .* | sort -n'
alias 'fcs=(for i in * .*(N); do echo $(find $i -type f | wc -l) "\t$i"; done) | sort -n'
alias 'fcs.=(for i in .*; do echo $(find $i -type f | wc -l) "\t$i"; done) | sort -n'
alias 'last=last -a'
alias 'zap=clear; echo -en "\e[3J"'
alias 'rmedir=rmdir -v **/*(/^F)'
alias 'xmlindent=xmlindent -t -f -nbe'
alias 'psqltsv=psql -X -t -A -F"	"'
alias 'qr=qrencode -t UTF8'

# Typing errors...
alias 'cd..= cd ..'

# Global aliases (expand whatever their position)
#  e.g. find . E L
alias -g :E='2> /dev/null'
alias -g :C='| wc -l'
alias -g :H='| head'
alias -g :L='|& less'
alias -g :S='| sort'
alias -g :SN='| sort -n'
alias -g :T='| tail'
unglobalalias() {
    for i in ':E' ':C' ':H' ':L' ':S' ':SN' ':T'; unalias $i
}

# Log file viewing
lastlogdir=logs
alias taillast='tail -f $lastlogdir/*(om[1])'
alias catlast='< $lastlogdir/*(om[1])'
alias lesslast='less $lastlogdir/*(om[1])'

# Quick TSV/CSV file formatting
tsv() {
    if [[ -t 1 ]]; then
        column -n -s "	" -t $* | less
    else
        column -n -s "	" -t $*
    fi
}
csv() {
    # csvtool
    if [[ -t 1 ]]; then
        column -n -s , -t $* | less
    else
        column -n -s , -t $*
    fi
}

# chop - limit lines to terminal size
# 14jun2016  +chris+
chop() { cut -c-${COLUMNS:-80} }

# SSH aliases
alias 'sshb=ssh matt@blissett.me.uk'
alias 'sshstop=ssh -O stop'

# SSH to shell[1234].doc.ic.ac.uk at random
sshdoc() {
    ssh mrb04@shell$(($RANDOM % 4 + 1)).doc.ic.ac.uk $*
}

# Remove a known host and its IP from the cache
ssh-knownhosts-remove() {
    ssh-keygen -R $1
    ssh-keygen -R $(dig $1 +short)
}

ssh-knownhosts-remove-by-line() {
    echo "Not implemented"
    # sed -e '800d' | sponge...?
}

# Automatically background processes (no output to terminal etc)
z () {
    grey='\e[1;30m'
    norm='\e[m'
    outfile=$(mktemp --tmpdir ${1//\//}.XXX)
    echo "$grey$* &> $outfile$norm"
    $* &>! $outfile &!
}
compdef z=sudo

# Aliases to use this
# Use e.g. 'command gv' to avoid
for i in acroread akregator amarok ario audacity chromium-browser darktable dolphin easytag eclipse \
    firefox gimp gpdf gpsprune gv gwenview hugin idea inkscape kate kmag konqueror ktorrent kwrite \
    libreoffice lobase localc lodraw loffice lomath loffice lowriter \
    okular see skype skypeforlinux thunderbird; do
    alias "$i=z $i"
done

# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

# Quick regex history search
zh() {
    pattern=^$(echo '(?=.*'${^@}')' | tr -d ' ')
    grep --text ~/.zsh_history --perl-regexp --regexp $pattern
}

# Remap Dvorak-Qwerty quickly
alias 'aoeu=setxkbmap gb -option' # (British keyboard layout, no special options)
alias 'asdf=setxkbmap gb dvorak -option compose:menu,ctrl:swapcaps,terminate:ctrl_alt_bksp,lv3:ralt_alt 2> /dev/null || setxkbmap dvorak gb 2> /dev/null || setxkbmap dvorak'

# Change between English and Danish
english() {
    export LANG=en_GB.UTF-8
    export LANGUAGE=en_GB:en
}
danish() {
    export LANG=da_DK.UTF-8
    export LANGUAGE=da_DK:da
}

# Bring emacs to foreground, or else edit last-modified file
e() {
    jobs emacs && fg emacs || emacs *(.om[1]^D)
}

# Change terminal title
title() {
    echo -ne "\033]30;$*\007"
}

# Update config files (master copies stored on server)
alias pull-config='(cd ~/.matt-config; git --git-dir=$HOME/.matt-config/.git pull --rebase && . ~/.zshrc)'

pull-config-regularly() {
    if [[ -z "$SSH_CONNECTION" ]]; then
        if after 1 day $HOME/.pull-config-regularly; then
            echo "Pulling config"
            pushd ~/.matt-config
            git pull --rebase
            popd
            touch $HOME/.pull-config-regularly
        fi
    fi
}
pull-config-regularly

# Check dot-files are up-to-date
~/.matt-config/make-links

# Named directories
hash -d config=$HOME/.matt-config
hash -d bin=$HOME/.matt-config/bin
hash -d log=/var/log

# notes — switch to current notes folder, creating it if needed
notes xxx () {
  set +e
  DIR=~/$0/$(date +%G/%V)
  [[ -d $DIR ]] || {
    mkdir -p $DIR
    ln -sfn $DIR ~/$0/current
    echo "Created $DIR."
  }
  cd ~/$0/current
}

# mkcd -- mkdir and cd at once
mkcd() { mkdir -p -- "$1" && cd -- "$1" }
compdef mkcd=mkdir

# When directory is changed set xterm title to host:dir
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
	sun-cmd) print -Pn "\e]l%~\e\\";;
        *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%m:%~\a";;
    esac
}

# For changing the umask automatically
chpwd () {
    case $PWD in
        $HOME/[Dd]ocuments*)
            if [[ $(umask) -ne 077 ]]; then
                umask 0077
                echo >&2 -e "\033[01;32mumask: private \033[m"
            fi;;
        /nothing)
            if [[ $(umask) -ne 072 ]]; then
                umask 0072
                echo >&2 -e "\033[01;33mumask: other readable \033[m"
            fi;;
        /nothing)
            if [[ $(umask) -ne 002 ]]; then
                umask 0002
                echo >&2 -e "\033[01;35mumask: group writable \033[m"
            fi;;
        *)
            if [[ $(umask) -ne 022 ]]; then
                umask 0022
                echo >&2 -e "\033[01;31mumask: world readable \033[m"
            fi;;
    esac
}
cd . &> /dev/null

# For quickly plotting data with gnuplot.  Arguments are files for 'plot "" with lines'.
plot () {
    echo -n '(echo set term png; '
    echo -n 'echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot | display png:-'

    (
	echo "set term png"
	echo -n plot \"$1\" with lines
	for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
	) | gnuplot | display png:-
}
# Persistant gnuplot (can be resized etc)
plotp () {
    echo -n '(echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot -persist'

    (
	echo -n plot \"$1\" with lines
	for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
	echo
	) | gnuplot -persist
}

# CD into random directory in PWD
cdrand () {
	all=( *(/) )
	rand=$(( 1 + $RANDOM % $#all ))
	cd $all[$rand]
}

# up [|N|pat] -- go up 1, N or until basename matches pat many directories
#   just output directory when not used interactively, e.g. in backticks
# 06sep2013  +chris+
# 11oct2017  +leah+  add completion
up() {
    local op=print
    [[ -t 1 ]] && op=cd
    case "$1" in
        '')
            up 1
            ;;
        -*|+*)
            $op ~$1
            ;;
        <->)
            $op $(printf '../%.0s' {1..$1})
            ;;
        *)
            local -a seg; seg=(${(s:/:)PWD%/*})
            local n=${(j:/:)seg[1,(I)$1*]}
            if [[ -n $n ]]; then
                $op /$n
            else
                print -u2 up: could not find prefix $1 in $PWD
                return 1
            fi
    esac
}
_up() { compadd -V segments -- ${(Oas:/:)PWD} }
compdef _up up
alias up=' up'

# Rotate a jpeg, losslessly
#jrotate-r () {
#    for i in $*; do
#	exiftran -9 -b -i $i
#    done
#}

# Calculate the difference in whole days between two dates, ignoring timezone changes
datediff () {
    echo $(( ($(date -u -d $1 +%s) - $(date -u -d $2 +%s)) / 86400))
}

# Close Amarok and shut down
bedtime-awake () {
    sleep ${1}m
    qdbus org.kde.amarok /Player StopAfterCurrent > /dev/null
    t=-10
    while [[ $t -lt 600 ]] && \
	qdbus --literal org.kde.amarok /Player GetStatus > /dev/null && \
	qdbus --literal org.kde.amarok /Player GetStatus | grep -vq 2
    do
	((t = t+10))
	echo -n "\rWaited" $t "seconds"
	sleep 10;
    done
    echo "\rQuitting"
    qdbus org.kde.amarok / Quit
    qdbus org.ktorrent.ktorrent /MainApplication quit &> /dev/null
}

bedtime () {
    bedtime-awake ${1}
    sudo shutdown -h 1
}

untilquit () {
    while c=$(pgrep -c -x ${1}); do echo -n "\r${c} ${1} processes remaining." && sleep 2; done; echo;
}

untilquitpid () {
    while kill -0 ${1} &> /dev/null; do echo -n "\rProcess with PID ${1} is still running." && sleep 2; done; echo;
}

untilquitmatch () {
    while c=$(pgrep -c -f ${*}); do echo -n "\r${c} ${1} matching processes remaining." && sleep 2; done; echo;
}

# MySQL prompt
export MYSQL_PS1="\R:\m:\s \h.\d> "

# export MAVEN_OPTS="-DdownloadSources=true -DdownloadJavadocs=true $MAVEN_OPTS"

# Build a GBIF AsciiDoctor document
builddoc () {
    doclang=${1:-en}
    docker run --rm -it -e PRIMARY_LANGUAGE=$doclang --user $(id -u):$(id -g) -v $PWD:/documents/ gbif/asciidoctor-toolkit
}

# Print some stuff
date +%c
if [[ -x `which fortune 2> /dev/null` ]]; then
    echo
    fortune -a 2> /dev/null
fi

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"
# End of lines added by compinstall

# Completers for my own scripts
zstyle ':completion:*:*:(album-cover|copy-geotag):*' file-patterns '*.(#i)(jp*g|png|tif*)'

zstyle ':completion:*:*:photo-sort:*' file-patterns '*(/)'
zstyle ':completion:*:*:photo-sort:*' file-sort time

compdef untilquit=pkill

# Don't complete backup files as commands.
zstyle ':completion:*:complete:-command-::*' ignored-patterns '*\~'

# Username completion.
# Delete old definitions
zstyle -d users
# For SSH and Rsync, use remote users set in SSH configuration, plus root
zstyle ':completion:*:*:(ssh|rsync):*' users root $(awk '$1 == "User" { print $2 }' ~/.ssh/config | sort -u)
# For everything else, use non-system users from /etc/passwd, plus root
zstyle ':completion:*:*:*:*' users root $(awk -F: '$3 > 1000 && $3 < 65000 { print $1 }' /etc/passwd)

# Hostname completion
zstyle ':completion:*' hosts $( grep -h '\.' $HOME/.hosts* )

# URL completion. Use URLs from history.
zstyle -e ':completion:*:*:urls' urls 'reply=( ${${(f)"$(egrep --only-matching \(ftp\|https\?\)://\[A-Za-z0-9\].\* $HISTFILE)"}%%[# ]*} )'

# Quote stuff that looks like URLs automatically.
#autoload -U url-quote-magic
#zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
#zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='
#zle -N self-insert url-quote-magic

# File/directory completion, for cd command
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'
#  and for all commands taking file arguments
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'

# Prevent offering a file (process, etc) that's already in the command line.
zstyle ':completion:*:(rm|cp|kill|diff|scp):*' ignore-line yes
# (Use Alt-Comma to do something like "mv abcd.efg abcd.efg.old")

# Completion selection by menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Filename suffixes to ignore during completion (except after rm command)
# This doesn't seem to work
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(^rm):*' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
# Although this does work
zstyle ':completion:*:emacs:*' ignored-patterns '*.asis' '*~'
zstyle '*' single-ignored show

# Finenames to prefer/limit during completion
zstyle ':completion:*:*:loffice:*' file-patterns '*.(doc|docx|dot|dotx|xls|xlsx|xlt|xltx|odt|ods|csv|tsv|txt):documents *(-/):directories' '%p:all-files'

zstyle ':completion:*:*:rmdir:*' file-sort time

#[[ -d /web/matt.blissett.me.uk]] && zstyle ':completion:*' local matt.blissett.me.uk /web/matt.blissett.me.uk

# CD to never select parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## Use cache
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Quick ../../.. from https://github.com/blueyed/oh-my-zsh
resolve-alias() {
    # Recursively resolve aliases and echo the command.
    typeset -a cmd
    cmd=(${(z)1})
    while (( ${+aliases[$cmd[1]]} )) \
	      && [[ ${aliases[$cmd[1]]} != $cmd ]]; do
	cmd=(${(z)aliases[${cmd[1]}]})
    done
    echo $cmd
}
rationalise-dot() {
    # Auto-expand "..." to "../..", "...." to "../../.." etc.
    # It skips certain commands (git, tig, p4).
    #
    # resolve-alias is defined in a separate function.

    local MATCH # keep the regex match from leaking to the environment.

    # Skip pasted text.
    if (( PENDING > 0 )); then
	zle self-insert
	return
    fi

    if [[ $LBUFFER =~ '(^|/| ||'$'\n''|\||;|&)\.\.$' ]] \
	   && ! [[ $(resolve-alias $LBUFFER) =~ '(git|tig|p4)' ]]; then
	LBUFFER+=/
	zle self-insert
	zle self-insert
    else
	zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert 2>/dev/null

autoload zsh/sched

# Copys word from earlier in the current command line
# or previous line if it was chosen with ^[. etc
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

# Cycle between positions for ambigous completions
autoload cycle-completion-positions
zle -N cycle-completion-positions
bindkey '^[z' cycle-completion-positions

# Increment integer argument
autoload incarg
zle -N incarg
bindkey '^X+' incarg

# Write globbed files into command line
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files

# Play tetris
#autoload -U tetris
#zle -N tetris
#bindkey '^X^T' tetris

# xargs but zargs
autoload -U zargs

# Calculator
autoload zcalc

# Line editor
autoload zed

# Renaming with globbing
autoload zmv

# Add Git functions 
#if [[ -d ~/.matt-config/zsh-git/functions ]]; then
#    fpath=($fpath ~/.matt-config/zsh-git/functions)
#    typeset -U fpath
#    setopt promptsubst
#    autoload -U promptinit
#    promptinit
#    prompt wunjo
#fi
if [[ -e zsh-git-prompt/zshrc.sh ]]; then
    source zsh-git-prompt/zshrc.sh
    RPROMPT='$(git_super_status)'
fi

# Git completion, retrieved from https://git.kernel.org/cgit/git/git.git/tree/contrib/completion/git-completion.zsh
if [[ -f ~/.matt-config/git-completion.zsh ]]; then
    fpath=(~/.matt-config/git-completion.zsh $fpath)
fi

# PRLL, for parallel shell processing
if [[ -e ~/.matt-config/prll/prll.sh ]]; then
    source ~/.matt-config/prll/prll.sh
fi

# Various reminders of things I forget...
# (Mostly useful features that I forget to use)
# vared
# =ls turns to /bin/ls
# =(ls) turns to filename (which contains output of ls)
# <(ls) turns to named pipe
# ^X* expand word
# ^[^_ copy prev word
# ^[A accept and hold
# echo $name:r not-extension
# echo $name:e extension
# echo $xx:l lowercase
# echo $name:s/foo/bar/

# Quote current line: M-'
# Quote region: M-"

# Up-case-word: M-u
# Down-case-word: M-l
# Capitilise word: M-c

# kill-region

# expand word: ^X*
# accept-and-hold: M-a
# accept-line-and-down-history: ^O
# execute-named-cmd: M-x
# push-line: ^Q
# run-help: M-h
# spelling correction: M-s

# echo ${^~path}/*mous*

# Add host/domain specific zshrc
domainname() {
    setopt extended_glob local_options
    hostname -d 2> /dev/null || echo ${$(hostname -f)#[a-z0-9-]##\.}
}

if [ -f $HOME/.zshrc-$(domainname) ]
then
    . $HOME/.zshrc-$(domainname)
fi

if [ -f $HOME/.zshrc-$HOST ]
then
    . $HOME/.zshrc-$HOST
fi

if [ -f $HOME/.zshrc-$(hostname -f) ]
then
    . $HOME/.zshrc-$(hostname -f)
fi

Also see these other dotfiles:

    .editorconfig
    .lessfilter

This page was last modified on 12 May 2019.
This work by Matthew Blissett is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.

