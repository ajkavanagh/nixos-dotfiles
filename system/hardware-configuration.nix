# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."root-crypt-p3".device = "/dev/disk/by-uuid/a41df29c-41c5-469d-bd22-ed15ecf6424a";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@var_log" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  fileSystems."/srv" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@srv" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/7ce21c70-39e5-47d2-a2db-c9a7bbf358d9";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5354-00B4";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fc48ffc3-5749-4754-8756-eb6f9259dce4"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
