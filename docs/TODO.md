# TODO

Things to sort out on the framework NixOS laptop

* Setup console to use uk keymap
* Get configuration.nix stored in a git repository. (maybe even this one).
* Add in homemanager
* Setup neovim as the editor (and get my config across for it).
  - Use the flake: https://github.com/neovim/neovim/wiki/Building-Neovim#nixos--nix
  - Also: https://nixos.wiki/wiki/Neovim
* Set up alacritty
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

# DONE

* 2022-05-19: Setup hibernate to use the encrypted swap device. https://www.worldofbs.com/nixos-framework/
