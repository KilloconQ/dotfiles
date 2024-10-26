{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let 
    user = builtins.getEnv "USER";  # Detectar el usuario dinámicamente.
  in {
    homeConfigurations = {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        # Configuración del usuario.
        home.username = user;
        home.stateVersion = "23.05";

        modules = [
          ./home.nix
        ];
      };
    };
  };
}
