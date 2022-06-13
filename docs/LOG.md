# Log

## Install 2022-05-17

(Reformat this someplace else ...)

There were a number of things I couldn't do in the initial install:

 - Set console up (it complained about keyMap being a duplicate key ... due to the keymaps not being available at install time)
 - Anything to do with tlp -- just broke.

## Post re-boot

- Got tlp to install properly // site: 

## Swap device working:

Got swap device to work in configuration.nix by adding.

boot.initrd.luks.devices."swap-crypt-p2".device = "/dev/disk/by-uuid/...";
boot.initrd.luks.devices."root-crypt-p3".device = "/dev/disk/by-uuid/...";

Then the device that was 'auto-found' when hardware-configuration.nix was generated (as part of the filesystems. stuff).

## installed nix-index using nix-env

TODO: need to remove nix-index as a nix-env, and re-install it via home-manager as a user program.

## using the framework hardware.nix from https://github.com/NixOS/nixos-hardware

Added `<nixos-hardware/framework>` to the input section of the `/etc/nixos/configuration.nix`.

I needed to remove a few things from my `configuration.nix` as they were already placed in nixos-hardware.  This is a good thing as it makes it a bit more 'default' and less likely to break.

Used `nixos-rebuild reboot` to set it up and then rebooted.

## Set up system to hiberbate

Used instructions at: https://www.worldofbs.com/nixos-framework/

Essentially, set the resumeDevice to be the UUID of the encrypted device and then setup the `services.logind` to match the above website.

## 2022-05-21 -- Enabled nix flakes on the system

Followed https://christine.website/blog/nix-flakes-1-2022-02-21

Essentially add `nix = { ... };` to the `configuration.nix` and do a nixos-rebuild switch

## 2055-06-02 -- Enable git-crypt on the .dotfiles repository

Firstly, I renamed the `.nixos-dotfiles` directory to `.dotfiles` and made the changes to `maint-scripts/apply-system` and `maint-scripts/apply-user` as it's smaller to type and doesn't interfere with other `.nix*` directories/files in `$HOME`; this affects completion, so seems like a good move.

References:

 * https://www.agwa.name/projects/git-crypt/
 * https://github.com/AGWA/git-crypt

Then, I enabled git-crypt.  This is so that I can store the contents of my `$HOME/.ssh` directory in this repository, and obviously, I don't want to share those secrets!

Commands

```bash
cd ~/.dotfiles
git crypt init
git crypt add-gpg-user alex@ajkavanagh.co.uk

# And to export the shared key (from the init):
git crypt export-key ~/Downloads/nixos-dotfiles-gpg.key

# Now for where the files get stored
# Note that the filenames are not encrypted, only the contents.
mkdir .secrets
```

The create a `.gitattributes` file as so:

```bash
~/.dotfiles]$ cat .gitattributes 
.secrets/** filter=git-crypt diff=git-crypt
```

Then to lock and unlock the git repository:

```bash
git crypt lock
git crypt unlock
```

# Mullvad-vpn (2022-06-05)

To summarize for anyone else wanting to setup mullvad VPN on NixOS (as of 2021-08-04)...

    Add the following to /etc/nixos/configuration.nix:

  networking.firewall.checkReversePath = "loose";
  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;

    nixos-rebuild switch and reboot.

    nix-shell -p mullvad-vpn
    mullvad connect

    Follow https://mullvad.net/en/help/how-use-mullvad-cli/

From: https://github.com/NixOS/nixpkgs/issues/113589#issuecomment-893233499

# Nerd Fonts (2022-06-11)

Installing Nerd fonts (for alacritty) turned out to be easier that I had guessed.  Essentially followed: https://discourse.nixos.org/t/home-manager-nerdfonts/11226 which describes how to add it to the home-manager config.  Although, my neovim seems to be acting up a little, so I might need to switch to 0.6 rather than nightly.

# Setting up caplocks as escape and switching them

This turns out to be a bit more complex than I thought.  Essentially, I needed to install something called [`interception tools`](https://gitlab.com/interception/linux/tools) which is:

> A minimal composable infrastructure on top of libudev and libevdev

However, the default didn't work due to this [bug](https://github.com/NixOS/nixpkgs/issues/126681).  i.e. it may or may not work depending on the order in which the evaluation is done, which is deliberately undefined in the functional language.  Therefore, the [comment](https://github.com/NixOS/nixpkgs/issues/126681#issuecomment-860071968) actually provides the solution, which I added to the `configuration.nix`:

```nix
# Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
services.interception-tools = {
  enable = true;
  plugins = [ pkgs.interception-tools-plugins.caps2esc ];
  udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  ''
```
