{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = if builtins.hasPrefix "Darwin" (builtins.currentSystem) 
             then "x86_64-darwin" 
             else "x86_64-linux";
  in {
    homeConfigurations = {
      killoconq = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home.nix ];  # Aquí se define tu configuración.
      };
    };
    
    # Esto asegura que la configuración sea accesible como activación.
    packages.${system}.activationPackage = 
      homeConfigurations.killoconq.activationPackage;
  };
}
