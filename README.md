# Frame.work NixOS "Dotfiles" and initial installation / preparation scripts

This is the config for my Frame.work laptop. It's very much a work in progress, so don't consider it to be in anyway complete.  At present it results in a completely unconfigured GNOME based system without any particularly usable tools.

 * See the [TODO](./docs/TODO.md) for further work to be done.
 * The [LOG](./docs/LOG.md) contains my general ramblings as I worked out how to do things.

Note this is my first attempt at Nix and NixOS so it's not exactly 'good'. Expect it to be quite bad, in fact, and there to be a lot of churn as I understand more about the Nix language and how to use it to configure the laptop.  Eventually, it'll make (hopefully) it's way over to my desktop and then on to my servers.

The plan:

 * Script to partition the disk, label and type appropriately.
 * Script to encrypt the disks, using a simple password (later to be erased).
 * Script to mount them the disks to the correct place.
 * Capture config files (more later) so that the encrypted disk is used.

## Where is stuff?

 * `install-scripts/` - the initial scripts to run from a live CD to prepare the 'disk' with partitions and the LUKS encryption.
 * `docs/` - documents describing what is done, issues, TODO list, etc.  All in markdown format.
 * (TODO) `configuration.nix` - the configuration for the main system.
 * (TODO) `modules/` - the Nix configuration broken down into modules, and imported into the main `configuration.nix` file.
 * (TODO) `home.nix` - the configuration file for home-manager.
 * (TODO) `home-modules/` - (if ever needed), home-manager broken down into separate, importable modules.
 * (TODO) `scripts/` - scripts used to maintain the system. e.g. to do updates, etc.  These are symlinked into `$HOME/.local/bin` so that they can be used from the CLI easily.
