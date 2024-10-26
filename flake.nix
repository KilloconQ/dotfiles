{
  description = "Home Manager Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, home-manager }: {
    homeConfigurations.fernando = home-manager.lib.homeManagerConfiguration {
      # Detecta automáticamente el sistema (macOS con Intel o Linux).
      pkgs = import nixpkgs {
        system = builtins.currentSystem or (if builtins.isDarwin then "x86_64-darwin" else "x86_64-linux");
      };

      modules = [
        ./nix/home.nix
      ];
    };
  };
}
