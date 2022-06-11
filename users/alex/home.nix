{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configuration starts here:
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # Packages installed for this user:
  home.packages = with pkgs;
  [
    alacritty
    bitwarden
    fd
    gcc
    git-crypt
    gnupg
    mattermost-desktop
    neovim-nightly
    python3Full
    nodejs
    nodePackages.neovim
    ripgrep
    silver-searcher
    tree-sitter
  ];

  # Let Home Manager manage bash
  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    XCURSOR_THEME = "Adwaita";  # may need to revist for sway?
  };

  # configure neovim to use the submodule vcsh_nvim config files
  # that are shared with vcsh on Ubuntu until I can move everything
  # over to Nix.  Note that vcsh_nvim the config is in a .config/nvim
  # which you can't see unless you do `ls -al`
  xdg.configFile.nvim = {
    source = ../../submodules/vcsh_nvim/.config/nvim;
    recursive = true;
  };

  # Set up non-declarative syncthing and syncthing.tray
  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;
}
