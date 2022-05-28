# NixOS "Dotfiles" and initial installation / preparation scripts

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
