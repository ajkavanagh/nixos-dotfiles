#/bin/bash
set -ex

source ./vars.sh
source ./utils.sh

is_mounted "/mnt" || {
    echo "Already mounted, so nothing to do"
    exit 0
}

# check if mounts need opening
if [ ! -e /dev/mapper/swap-crypt-p2 ]; then
    echo -n "$PASSPHRASE" | cryptsetup open ${DEV_P2} ${SWAP_CRYPT_NAME}
fi
if [ ! -e /dev/mapper/root-crypt-p3 ]; then
    echo -n "$PASSPHRASE" | cryptsetup open ${DEV_P3} ${ROOT_CRYPT_NAME}
fi

# Mount the '@' subvolume to /mnt
mount ${BTRFS_MOUNT_OPTIONS_}@ /dev/mapper/${ROOT_CRYPT_NAME} /mnt
# mount the relavent subvolumes to their mount points:
mount ${BTRFS_MOUNT_OPTIONS_}@nix /dev/mapper/${ROOT_CRYPT_NAME} /mnt/nix
mount ${BTRFS_MOUNT_OPTIONS_}@home /dev/mapper/${ROOT_CRYPT_NAME} /mnt/home
mount ${BTRFS_MOUNT_OPTIONS_}@var_log /dev/mapper/${ROOT_CRYPT_NAME} /mnt/var/log
mount ${BTRFS_MOUNT_OPTIONS_}@tmp /dev/mapper/${ROOT_CRYPT_NAME} /mnt/tmp
mount ${BTRFS_MOUNT_OPTIONS_}@srv /dev/mapper/${ROOT_CRYPT_NAME} /mnt/srv
mount ${BTRFS_MOUNT_OPTIONS_}@snapshots /dev/mapper/${ROOT_CRYPT_NAME} /mnt/.snapshots

# mount the efi partition in
mount ${DEV_P1} /mnt/boot
