{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations.killoconq = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # Definimos explícitamente las opciones necesarias para evitar errores.
      home.username = "killoconq";
      home.stateVersion = "23.05";

      modules = [
        ./home.nix
      ];
    };
  };
}
