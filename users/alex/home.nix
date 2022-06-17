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

  # Switch fonts on; they get installed in home.packages
  fonts.fontconfig.enable = true;

  # Packages installed for this user:
  home.packages = with pkgs;
  [
    alacritty
    bitwarden
    cargo
    cmake
    fd
    gcc
    git-crypt
    gnupg
    mattermost-desktop
    neovim-nightly
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    (python39.withPackages(ps: with ps; [ pynvim pip ]))
    nodejs
    nodePackages.neovim
    ripgrep
    silver-searcher
    tree-sitter
    unzip
  ];

  # Let Home Manager manage bash
  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    TERM = "xterm-256color";
    XCURSOR_THEME = "Adwaita";  # may need to revist for sway?
    QT_QPA_PLATFORM = "wayland";  # for QT apps that run python?
  };

  # configure neovim to use the submodule vcsh_nvim config files
  # that are shared with vcsh on Ubuntu until I can move everything
  # over to Nix.  Note that vcsh_nvim the config is in a .config/nvim
  # which you can't see unless you do `ls -al`
  xdg.configFile.nvim = {
    source = ../../submodules/vcsh_nvim/.config/nvim;
    recursive = true;
  };

  # configure alacritty to use the submodule vcsh_misc-config files
  # that are shared with vcsh on Ubuntu.  This is temporary until I can
  # work out how to do it properly in nix/home-manager
  xdg.configFile.alacritty = {
    source = ../../submodules/vcsh_misc-config/.config/alacritty;
    recursive = true;
  };

  # Setup git using submodules/vcsh_misc-config/.gitconfig and related
  # files; this is a temporary measure whilst they are shared with Ubuntu
  home.file.".gitconfig".source = ../../submodules/vcsh_misc-config/.gitconfig;
  home.file.".gitconfig.d" = {
    source = ../../submodules/vcsh_misc-config/.gitignore.d;
    recursive = true;
  };
  # TODO: need to add the .gitignore_global file here and add it from laptop into
  #       the vcsh_misc-config module


  # Set up non-declarative syncthing and syncthing.tray
  services.syncthing.enable = true;
  services.syncthing.tray.enable = false;  # broken on Gnome on wayland?

  # Add zoxide to the shell (as z and zi) as these are handy as a jump program
  programs.zoxide.enable = true;

  # Starship prompt, declaratively in this module (ignoring the file in vcsh_misc-config submodule
  programs.starship = {
    enable = true;
    # Settings written to ~/.config/starship.toml
    settings = {
      username.show_always = true;
      username.format = "[$user](dimmed)";

      hostname = {
        ssh_only = false;
        #format = "@[$hostname]($style): "
        format = "@[$hostname](dimmed): ";
      };

      git_branch.format = "on [$symbol$branch](dimmed) ";
      git_status.format = "([\\[$all_status$ahead_behind\\]](dimmed fg:red) )";

      line_break.disabled = true;

      cmd_duration.disabled = true;

      rust.disabled = true;
    };
  };
}
