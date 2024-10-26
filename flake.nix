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
    # Detectar el nombre del usuario actual dinámicamente.
    user = builtins.getEnv "USER"; 
  in {
    homeConfigurations = {
      ${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        # Establecer dinámicamente el nombre del usuario.
        home.username = user;
        home.stateVersion = "23.05";  # Asegúrate de usar la versión correcta.

        modules = [
          ./home.nix
        ];
      };
    };
  };
}
