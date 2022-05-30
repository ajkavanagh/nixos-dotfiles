# Understanding and using TPM2 in NixOS

## Goal

Sign all the boot items and store the keys in the TPM so that secure boot can be used to boot the machine, unlock the LUKS encrypted partitions.

## TODO

 * Understanding signing and tools available in NixOS
 * Understanding the NixOS boot
 * Determining the bits that are missing
 * Working out next steps

## References / Reading

 * systemd: add missing TPM2 build dependencies (merged) https://github.com/NixOS/nixpkgs/pull/139864/files
