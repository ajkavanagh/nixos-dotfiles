{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";

    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixos-hardware = {
      #url = github:NixOS/nixos-hardware/master;
      #inputs.nixpkgs.follows = "nixpkgs";
    #};
    nixos-hardware.url = github:NixOS/nixos-hardware/master;


  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        alex-fw = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-hardware.nixosModules.framework
            ./system/hardware-configuration.nix
            ./system/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./users/alex/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      #devShell.${system} = (
        #import ./outputs/installation.nix {
          #inherit system nixpkgs;
        #}
      #);
    };
}
