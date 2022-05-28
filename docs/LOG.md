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

