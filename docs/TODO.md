# TODO

Things to sort out on the framework NixOS laptop

* Setup console to use uk keymap
* Setup neovim as the editor (and get my config across for it).
  - Use the flake: https://github.com/neovim/neovim/wiki/Building-Neovim#nixos--nix
  - Also: https://nixos.wiki/wiki/Neovim
* Set up alacritty in home manager
* Set up sway
  - https://gist.github.com/kborling/76805ade81ac5bfdd712df294208c878
  - useful info: https://shibumi.dev/posts/wayland-in-2021/  -- arch, but adaptable.
* Setup pipewire: https://nixos.wiki/wiki/PipeWire
* Setup distrobox (maybe?)
  - Issue merged: https://github.com/NixOS/nixpkgs/pull/160251
  - https://github.com/89luca89/distrobox

* need to remove nix-index as a nix-env, and re-install it via home-manager as a user program. (needs homemanager configured).

* Set up LXD so we can do Ubuntu stuff on the laptop
* Set up mullvad VPN: https://github.com/NixOS/nixpkgs/issues/113589#issuecomment-893233499

## Home Manager TODOs

So Home Manager manages the users programs and dotfiles.  Need to migrate my vcsh dotfiles for various things into .dotfiles (here) so that I can get all my normal configuration across.  I'll probably do that by sourcing existing config files and maybe using git submodules to `vcsh_nvim`.  One issue is how to maintain consistent configuration between my Ubuntu machines and NixOS framework?

* How to have different home-manager config parts for different machines.  e.g. one on Ubuntu, one on NixOS?
* Neovim configs; need a way to share these between existing machines (VCSH) and the nixos-dotfiles/home-manager setup.
* alacritty - with the darcular theme, etc.



# DONE

* 2022-05-19: Setup hibernate to use the encrypted swap device. https://www.worldofbs.com/nixos-framework/
* 2022-06-02: Finished set up of .dotfiles [github.com/nixos-dotfiles](https://github.com/ajkavanagh/nixos-dotfiles) with git-crypt. Also moved the configuration.nix and ~/.config/nix/home.nix (home-manager) into the repostory.  Also added home-manager to the mix, but this was done over the last week or two.
