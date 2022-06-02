# Preparing the initial disk

 * Boot with liveCD
 * Partition the disk - `01-initial-disk-operations.sh`
 * Ensure the partitions are mounted - `02-ensure-partitions-mounted.sh`
 * Prepare the initial `configuration.nix`
 * Do the nix install.

## Partitions

To LVM or not-LVM, that is the question.  And the answer is almost certainly *no*.  Why?  Largely because it involves running another daemon on a laptop, and the whole point is to try to get the number of things *running* down to just the applications that absolutely have to.

So without LVM, we need to do things natively.  Fundamentally, we want a 32GB swap, a root and a home partition (for recovery) and these all need to be encrypted.  They also all need to use the same key, as we can't store the key in the initramfs/initrd (as it's not encrypted).

Essentially, we want:

|-----|------|-----------|---------------|-------------|-------------|
| Num | Type | label     | size          | Mount point | File system |
|-----|------|-----------|---------------|-------------|-------------|
| 1   | EFI  | boot      | 1GB           | /boot       | FAT32       |
|-----|------|-----------|---------------|-------------|-------------|
| 2   | LUKS | luks-swap | 32GB + 2MB    | crypt-swap  | swap        |
|-----|------|-----------|---------------|-------------|-------------|
| 3   | LUKS | luks-root | remain - 50GB | crypt-root  | btrfs       |
|-----|------|-----------|---------------|-------------|-------------|

And then we want sub volumes for the btrfs root so that we can snapshot different parts of the filesystem.

|----------|------------|---------------------------------------------------------------------------|
| Mount    | subvol     | purpose                                                                   |
|----------|------------|---------------------------------------------------------------------------|
| /        | @          | Be able to snapshot an empty root                                         |
|----------|------------|---------------------------------------------------------------------------|
| /home    | @home      | Snapshots of home are separate.                                           |
|----------|------------|---------------------------------------------------------------------------|
| /var/log | @var_log   | No snapshots of /var/log, but keep it separate from @ (/) snapshot        |
|----------|------------|---------------------------------------------------------------------------|
|          | @snapshots | Where the snapshots go to live.                                           |
|----------|------------|---------------------------------------------------------------------------|
| /tmp     | @tmp       | No snapshots of tmp                                                       |
|----------|------------|---------------------------------------------------------------------------|
| /nix     | @nix       | No snapshots of /nix - there's no point, it can be rebuilt.               |
|----------|------------|---------------------------------------------------------------------------|
| /srv     | @srv       | No snapshots of /srv - this is naughty software that isn't managed by nix |
|----------|------------|---------------------------------------------------------------------------|

And that should be enough to get going.

Thus, I need some scripts to get going:

1. Disk partition and encryption script, and subvolume script, using a passphrase as an encryption key.
2. Disk mounting script.

Then I need to work up the various `*.nix` config files that will be used to boot the computer.

Log:

Created a snapshot of root with:

```bash
sudo btrfs subv snapshot -r /mnt /mnt/.snapshots/@-blank
```


# Setting up the .dotfiles

* Remember to do the git-crypt stuff, particularly setting up the pre-commit hook
