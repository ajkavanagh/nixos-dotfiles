# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports = [
    # Use the https://github.com/NixOS/nixos-hardware definition for the framework
    <nixos-hardware/framework>

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree code
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # help out the LUKS boot:
  boot.initrd.luks.devices."swap-crypt-p2".device = "/dev/disk/by-uuid/a5238fc2-2699-4d70-b53f-ee5e18971dbf";
  boot.initrd.luks.devices."root-crypt-p3".device = "/dev/disk/by-uuid/a41df29c-41c5-469d-bd22-ed15ecf6424a";

  # Set up resume/hibernation support
  boot.resumeDevice = "/dev/disk/by-uuid/fc48ffc3-5749-4754-8756-eb6f9259dce4";

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

  # Enable the gpgagent
  programs.gnupg.agent.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    distrobox
    vim
    wget
    git
    file
    firefox-wayland
    google-chrome
    pinentry-gnome
    gnome.gnome-tweaks
    wl-clipboard
    mullvad-vpn
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

