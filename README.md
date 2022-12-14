# dotfiles


### Description
Dotfiles for my personal use.

### Requirement
### `Required`
- Neovim
- pyenv(python3 and 'neovim' module)
- zsh
- tmux
### `Optional`
- ag
- ctags

---

### Installation
### `Install`
```sh
$ cd ~
$ git clone https://github.com/keitaobbs/dotfiles.git
$ cd dotfiles
$ ./install.sh
```

---

### Note
### Install pyenv and pyenv-virtualenv
```sh
$ sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
$ git clone https://github.com/pyenv/pyenv.git ~/.pyenv
$ git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
```

### Fix error: -bash: warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)
```sh
$ localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
```

### git
#### `git clone`
```sh
$ git clone git@xxxxxx:keitaobbs/dotfiles.git
```
xxxxxx is a Host in .ssh/config (e.g. github-keitaobbs)

#### `git config`
```sh
$ git config --local user.name "keitaobbs"
$ git config --local user.email "keitaobbs@gmail.com"
```
