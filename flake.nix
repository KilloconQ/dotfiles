{
  description = "Home Manager Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations.fernando = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { };  # Importamos pkgs correctamente

      modules = [
        ./nix/home.nix  # Ruta correcta hacia home.nix
      ];
    };
  };
}
