# Used binaries
GIT := git
CURL := curl -sL
CRONTAB := crontab
LN := ln -sfn

# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
USER := Hung Dinh
EMAIL :=
SIGNKEY :=

.SILENT:
.PHONY: install gitconfig-user uninstall update upgrade

all: install

install: gitconfig-user
	touch ~/.hushlogin
	mkdir -p ~/.config/hexchat \
		~/.local/share/fonts \
		~/.ccache
	$(LN) "$$PWD"/alacritty ~/.config/alacritty
	$(LN) "$$PWD"/bat ~/.config/bat
	$(LN) "$$PWD"/clang/clang-format ~/.clang-format
	$(LN) "$$PWD"/ccache/ccache.conf ~/.ccache/ccache.conf
	$(LN) "$$PWD"/dunst ~/.config/dunst
	$(LN) "$$PWD"/fish ~/.config/fish
	$(LN) "$$PWD"/picom ~/.config/picom
	$(LN) "$$PWD"/gdb/gdbinit ~/.gdbinit
	$(LN) "$$PWD"/gdb/gdbinit.d ~/.gdbinit.d
	$(LN) "$$PWD"/ghci/ghci ~/.ghci
	$(LN) "$$PWD"/git/gitconfig ~/.gitconfig
	$(LN) "$$PWD"/git/gitignore_global ~/.gitignore_global
	$(LN) "$$PWD"/gtk/gtkrc-2.0 ~/.gtkrc-2.0
	$(LN) "$$PWD"/hexchat/colors.conf ~/.config/hexchat/colors.conf
	$(LN) "$$PWD"/htop ~/.config/htop
	$(LN) "$$PWD"/icons ~/.icons
	$(LN) "$$PWD"/i3 ~/.config/i3
	$(LN) "$$PWD"/i3status-rust ~/.config/i3status-rust
	$(LN) "$$PWD"/fonts/Meslo\ LG\ S\ DZ\ Regular\ Nerd\ Font\ Complete.ttf ~/.local/share/fonts/
	$(LN) "$$PWD"/fonts/Meslo\ LG\ S\ DZ\ Bold\ Nerd\ Font\ Complete.ttf ~/.local/share/fonts/
	$(LN) "$$PWD"/fonts/Meslo\ LG\ S\ DZ\ Italic\ Nerd\ Font\ Complete.ttf ~/.local/share/fonts/
	$(LN) "$$PWD"/nixpkgs ~/.config/nixpkgs
	$(LN) "$$PWD"/ranger ~/.config/ranger
	$(LN) "$$PWD"/rustfmt/rustfmt.toml ~/.rustfmt.toml
	$(LN) "$$PWD"/tig/tigrc ~/.tigrc
	$(LN) "$$PWD"/tmux/tmux.conf ~/.tmux.conf
	$(LN) "$$PWD"/tmux/tmux.local.conf ~/.tmux.local.conf
	$(LN) "$$PWD"/x11/Xdefaults ~/.Xdefaults
	$(LN) "$$PWD"/x11/profile ~/.profile
	$(LN) "$$PWD"/x11/xinitrc ~/.xinitrc
	$(LN) "$$PWD"/oh-my-zsh ~/.oh-my-zsh
	$(LN) "$$PWD"/zshrc ~/.zshrc
	$(LN) "$$PWD"/nvim ~/.config/nvim
	echo "Done installed"

uninstall:
	rm ~/.hushlogin
	rm ~/.config/alacritty
	rm ~/.config/bat
	rm ~/.clang-format
	rm ~/.ccache/ccache.conf
	rm ~/.config/dunst
	rm ~/.config/fish
	rm ~/.config/picom
	rm ~/.gdbinit
	rm ~/.gdbinit.d
	rm ~/.ghci
	rm ~/.gitconfig
	rm ~/.gitignore_global
	rm ~/.gtkrc-2.0
	rm ~/.config/hexchat/colors.conf
	rm ~/.config/htop
	rm ~/.config/i3
	rm ~/.config/i3status-rust
	rm ~/.icons
	rm ~/.local/share/fonts/Meslo\ LG\ S\ DZ\ Regular\ Nerd\ Font\ Complete.ttf
	rm ~/.local/share/fonts/Meslo\ LG\ S\ DZ\ Bold\ Nerd\ Font\ Complete.ttf
	rm ~/.local/share/fonts/Meslo\ LG\ S\ DZ\ Italic\ Nerd\ Font\ Complete.ttf
	rm ~/.config/nixpkgs
	rm ~/.config/ranger
	rm ~/.rustfmt.toml
	rm ~/.tigrc
	rm ~/.tmux.conf
	rm ~/.tmux.local.conf
	rm ~/.Xdefaults
	rm ~/.profile
	rm ~/.xinitrc
	rm ~/.oh-my-zsh
	rm ~/.zshrc
	rm -rf ~/.config/nvim
	rm $(GITCONFIG_USER_PATH)
	echo "Done uninstalled"

update:
	$(GIT) pull --rebase --autostash

upgrade: update
	$(CURL) "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S-DZ/Regular/complete/Meslo LG S DZ Regular Nerd Font Complete.ttf" \
		-o "fonts/Meslo LG S DZ Regular Nerd Font Complete.ttf"
	$(CURL) "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S-DZ/Bold/complete/Meslo LG S DZ Bold Nerd Font Complete.ttf" \
		-o "fonts/Meslo LG S DZ Bold Nerd Font Complete.ttf"
	$(CURL) "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S-DZ/Italic/complete/Meslo LG S DZ Italic Nerd Font Complete.ttf" \
		-o "fonts/Meslo LG S DZ Italic Nerd Font Complete.ttf"
	$(CURL) https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit -o gdb/gdbinit
	$(CURL) https://github.com/evanlucas/fish-kubectl-completions/raw/master/completions/kubectl.fish -o fish/completions/kubectl.fish
	$(CURL) https://github.com/junegunn/fzf/raw/master/shell/key-bindings.fish -o fish/functions/fzf_key_bindings.fish
	$(CURL) https://github.com/dracula/sublime/raw/master/Dracula.tmTheme -o bat/themes/Dracula.tmTheme
	$(CURL) https://github.com/wting/autojump/raw/master/bin/autojump.fish -o fish/functions/autojump.fish
	$(GIT) add -A
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -sm "Upgraded external dependencies"
	$(GIT) push

crontab:
	echo '0 * * * * cd ~/.dotfiles && make update 2>&1 >> /dev/null' > /tmp/crontab
	$(CRONTAB) /tmp/crontab
	rm /tmp/crontab
	$(CRONTAB) -l

gitconfig-user:
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signkey "$(SIGNKEY)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) commit.gpgsign true
	echo '# vi: syn=gitconfig' >> $(GITCONFIG_USER_PATH)
