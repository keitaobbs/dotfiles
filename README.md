# dotfiles

## Installation

```bash
./install.sh
```

## Trouble Shooting

### Strange texts leak into prompt when entering tmux

Small `escape-time` may prevent tmux from recognizing escape sequences that are fragmented across
packet boundaries. You should raise `escape-time` to a reasonable value such as 100ms.

### Zsh not installed and no sudo access

You can use [zsh-bin](https://github.com/romkatv/zsh-bin "zsh-bin") repository.

```text
$ sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
Choose installation directory for Zsh 5.8:

  (1) /usr/local        <= uses sudo (recommended)
  (2) ~/.local          <= does not need sudo
  (3) custom directory  <= manual input required

Choice: 2
```

### Ack not installed and no sudo access

```bash
$ curl https://beyondgrep.com/ack-v3.7.0 > ~/.local/bin/ack && chmod 0755 ~/.local/bin/ack
```
