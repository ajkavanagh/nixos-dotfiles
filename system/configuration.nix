# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
 # the nixos-hardware/framework, home-manager and hardware configuration are all imported in the flake's modules.
 # imports = [
    # Use the https://github.com/NixOS/nixos-hardware definition for the framework
 #   <nixos-hardware/framework>

    # Home manager as a module
 #   <home-manager/nixos>

    # Include the results of the hardware scan.
  #  ./hardware-configuration.nix
  #];

  # Allow unfree code
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # help out the LUKS boot:
  boot.initrd.luks.devices."swap-crypt-p2".device = "/dev/disk/by-uuid/0df473f3-ed77-4d28-8bb4-db16d4ff0c7c";
  boot.initrd.luks.devices."root-crypt-p3".device = "/dev/disk/by-uuid/acc397b2-a14a-4618-a32e-a35ef6880bd8";

  # Set up resume/hibernation support
  boot.resumeDevice = "/dev/disk/by-uuid/4528549c-b853-46df-a147-3cc2f4b6b5cb";

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=2h";

  # extra boot modules for crypt support.
  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];

  networking.hostName = "alex-fw"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "ter-v32n";
  #  keyMap = "gb";
  #  useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system + GNOME - we'll do Wayland later.
  services.xserver.enable = true;

  # Enable GNOME
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "gb";
  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  #  "eurosign:e";
  #  "caps:escape" # map caps to escape.
  #};

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  programs.system-config-printer.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # enable LXD virtualisation
  virtualisation.lxd.enable = true;

  # enable podman for the distrobox package
  virtualisation.podman = {
    enable = true;
    # Create a 'docker' alias for podman, as a docker replacement
    dockerCompat = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    home = "/home/alex";
    description = "Alex Kavanagh";
    initialPassword = "password";
    extraGroups = [ "wheel" "networkmanager" "lxd" ]; # "wheel" enables ‘sudo’ for the user.
  };

  # this is disabled as it is done in the flake.nix
  # Add in home-manager for the user
  # home-manager.useGlobalPkgs = true;
  # home-manager.users.alex = import ../users/alex/home.nix {pkgs=pkgs; lib=lib;};

  # Enable the gpgagent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    distrobox
    vim
    wget
    git
    git-review
    file
    firefox-wayland
    google-chrome
    pinentry-gnome
    gnome.gnome-tweaks
    wl-clipboard
    mullvad-vpn
    ipmiview
    killall
    dig.dnsutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable thermal data
  services.thermald.enable = true;

  # Fingerprint reader as login:
  # Note: services.fprintd.enable=true comes from <nixos-hardware/framework> default config.
  # disabled as I don't actually like the experience, nor security theatre
  # of the fingerprint reader.
  services.fprintd.enable=false;

  # Graphics stuff:
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    mesa_drivers
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

  # Configure mullvad to be available in the system for firewalls
  networking.firewall.checkReversePath = "loose";
  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;
  networking.extraHosts = ''
    10.245.160.2	churel
    10.245.168.6	ruxton-maas
    10.245.162.99   mosci
    10.245.162.58   osci
    10.245.164.110  zosci
    10.245.166.41   influxdb-bastion
    10.245.167.96   jupyter-bastion

    10.245.166.123	tinwood-charmcraft
    10.245.162.158	tinwood-bastion-xenial
    10.245.162.18	tinwood-bastion
    10.245.166.136	tinwood-focal
    10.245.165.179	tinwood-jammy
  '';

  # enable java
  programs.java.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

