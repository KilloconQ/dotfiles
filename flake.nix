{
  description = "Home Manager Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations.fernando = home-manager.lib.homeManagerConfiguration {
      inherit nixpkgs;

      pkgs = nixpkgs.pkgs;  # Pasamos 'pkgs' explícitamente aquí
      modules = [
        ./nix/home.nix  # Apuntamos al archivo home.nix
      ];
    };
  };
}
