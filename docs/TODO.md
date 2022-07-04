# TODO

Things to sort out on the framework NixOS laptop

* Setup bash aliases
* Fix syncthingtray which is broken due to qt5, wayland and GNOME and somthing to do with an environment variable. See [bug](https://github.com/nix-community/home-manager/issues/2963).

## 1st Round - getting something usable

* Setup console to use uk keymap
* IN PROGRESS: (started 2022-06-02) Setup neovim as the editor (and get my config across for it).
  - Use the flake: https://github.com/neovim/neovim/wiki/Building-Neovim#nixos--nix
  - Also: https://nixos.wiki/wiki/Neovim
* Set up alacritty
* Set up sway
  - https://gist.github.com/kborling/76805ade81ac5bfdd712df294208c878
  - useful info: https://shibumi.dev/posts/wayland-in-2021/  -- arch, but adaptable.
* Set up riverwm
* Setup pipewire: https://nixos.wiki/wiki/PipeWire

* [LOW] Setup console to use uk keymap

## Home Manager TODOs

So Home Manager manages the users programs and dotfiles.  Need to migrate my vcsh dotfiles for various things into .dotfiles (here) so that I can get all my normal configuration across.  I'll probably do that by sourcing existing config files and maybe using git submodules to `vcsh_nvim`.  One issue is how to maintain consistent configuration between my Ubuntu machines and NixOS framework?

* How to have different home-manager config parts for different machines.  e.g. one on Ubuntu, one on NixOS?

## Neovim TODOs

* Setup Neovim as a flake (it's currently an importable as vim.nix in the `vcsh_nvim` repo).
  - Use the flake: https://github.com/neovim/neovim/wiki/Building-Neovim#nixos--nix
  - Also: https://nixos.wiki/wiki/Neovim
* Install spelling dictionaries for English?
* Move the vim configuration to Lua (from vim script)
* Migrate the config out of the `vcsh_nvim` submodule (repo) when it is shut down (we don't really want to keep it as Nix is the future)??


## 2nd round - making it all declarative

* Syncthing?
* OpenVPN; the `~/.sesame` folder and configuring NetworkManager
* Mullvad-vpn; adding the account.
* SSH credentials; controlling the `~/.ssh` folder directly.
* Neovim; currently just a cargo cult of the `vcsh_nvim` repository.

## 3rd round - moving it to flakes

# DONE

* 2022-05-19: Setup hibernate to use the encrypted swap device. https://www.worldofbs.com/nixos-framework/
* 2022-05-30: Get configuration.nix stored in a git repository. (maybe even this one).
* 2022-05-30: Add in homemanager
* 2022-06-02: Finished set up of .dotfiles [github.com/nixos-dotfiles](https://github.com/ajkavanagh/nixos-dotfiles) with git-crypt. Also moved the configuration.nix and ~/.config/nix/home.nix (home-manager) into the repostory.  Also added home-manager to the mix, but this was done over the last week or two.
* 2022-06-02: Set up vpn so that I can access the Canonical network.  Only need SSH access and the VPN to be able to do work on the framework laptop.  Note that it's set up in a non-declarative way; be good to sort that at some point.
* 2022-06-03: Need mattermost setup so I can communicate; not the snap version!
* 2022-06-01: Install Nerdfonts; essentially followed: https://discourse.nixos.org/t/home-manager-nerdfonts/11226 which describes how to add it to the home-manager config.
* 2022-06-11: Set up alacritty in home manager; using the vcsh_misc-config alacritty git repo and using files from it for compatability with Ubuntu which isn't using Home Manager yet.
* 2022-06-12: Setup capslock as escape.
* 2022-06-12: Setup zoxide in home-manager by adding `programs.zoxide.enable = true;`
* 2022-06-13: Setup starship prompt; set up the configuration inside home-manager.
* 2022-06-13: Setup git configuration using the `vcsh_misc-config` submodule.
* 2022-06-22: Setup neovim as the editor (and get my config across for it).  See log for more details
* 2022-06-23: Set up LXD so we can do Ubuntu stuff on the laptop
* 2022-06-24: Setup distrobox (maybe?)
  - Issue merged: https://github.com/NixOS/nixpkgs/pull/160251
  - https://github.com/89luca89/distrobox
  - Also needs podman
* 2022-06-24: Set up mullvad VPN: https://github.com/NixOS/nixpkgs/issues/113589#issuecomment-893233499
* 2022-06-24: Removed nix-index as a nix-env, and re-installed it via home-manager as a user program.
