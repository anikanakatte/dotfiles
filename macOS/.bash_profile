export PATH="/usr/local/mysql/bin:$PATH"

# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/sbin:$PATH"

# PS1='\[\033[0;39m\]\[\033[0m\033[0;95m\]\u\[\033[0;39m\] @ \w\[\033[0;39m\]\n[$(git branch 2>/dev/null | grep '^*' | colrm 1 2)]\[\033[0;39m\] ▶\[\033[0m\033[0;39m\] '

# Colors
# RED="$(tput setaf 1)"
# GREEN="$(tput setaf 2)"
# YELLOW="$(tput setaf 3)"
# BLUE="$(tput setaf 4)"
# MAGENTA="$(tput setaf 5)"
# CYAN="$(tput setaf 6)"
# WHITE="$(tput setaf 7)"
# GRAY="$(tput setaf 8)"
# BOLD="$(tput bold)"
# UNDERLINE="$(tput sgr 0 1)"
# INVERT="$(tput sgr 1 0)"
# NOCOLOR="$(tput sgr0)"

# # User color
# case $(id -u) in
# 	0) user_color="$RED" ;;  # root
# 	*) user_color="$GREEN" ;;
# esac

# # Symbols
# prompt_symbol="❯"
# prompt_clean_symbol="☀ "
# prompt_dirty_symbol="☂ "
# prompt_venv_symbol="☁ "

# function prompt_command() {
# 	# Local or SSH session?
# 	local remote=
# 	[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && remote=1

# 	# Git branch name and work tree status (only when we are inside Git working tree)
# 	local git_prompt=
# 	if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
# 		# Branch name
# 		local branch="$(git symbolic-ref HEAD 2>/dev/null)"
# 		branch="${branch##refs/heads/}"

# 		# Working tree status (red when dirty)
# 		local dirty=
# 		# Modified files
# 		git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
# 		# Untracked files
# 		[ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1

# 		# Format Git info
# 		if [ -n "$dirty" ]; then
# 			git_prompt=" $RED$prompt_dirty_symbol$branch$NOCOLOR"
# 		else
# 			git_prompt=" $GREEN$prompt_clean_symbol$branch$NOCOLOR"
# 		fi
# 	fi

# 	# Virtualenv
# 	local venv_prompt=
# 	if [ -n "$VIRTUAL_ENV" ]; then
# 	    venv_prompt=" $BLUE$prompt_venv_symbol$(basename $VIRTUAL_ENV)$NOCOLOR"
# 	fi

# 	# Only show username if not default
# 	local user_prompt=
# 	[ "$USER" != "$local_username" ] && user_prompt="$user_color$USER$NOCOLOR"

# 	# Show hostname inside SSH session
# 	local host_prompt=
# 	[ -n "$remote" ] && host_prompt="@$YELLOW$HOSTNAME$NOCOLOR"

# 	# Show delimiter if user or host visible
# 	local login_delimiter=
# 	[ -n "$user_prompt" ] || [ -n "$host_prompt" ] && login_delimiter=":"

# 	# Format prompt
# 	first_line="$user_prompt$host_prompt$login_delimiter$WHITE\w$NOCOLOR$git_prompt$venv_prompt"
# 	# Text (commands) inside \[...\] does not impact line length calculation which fixes stange bug when looking through the history
# 	# $? is a status of last command, should be processed every time prompt prints
# 	second_line="\`if [ \$? = 0 ]; then echo \[\$CYAN\]; else echo \[\$RED\]; fi\`\$prompt_symbol\[\$NOCOLOR\] "
# 	PS1="\n$first_line\n$second_line"

# 	# Multiline command
# 	PS2="\[$CYAN\]$prompt_symbol\[$NOCOLOR\] "

# 	# Terminal title
# 	local title="$(basename "$PWD")"
# 	[ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
# 	echo -ne "\033]0;$title"; echo -ne "\007"
# }

# # Show awesome prompt only if Git is istalled
# command -v git >/dev/null 2>&1 && PROMPT_COMMAND=prompt_command

# if [ -f ~/.bashrc ]; then
#     source ~/.bashrc
# fi
###################################################################################

#new prompt
# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/opt/ruby/bin:$PATH"
