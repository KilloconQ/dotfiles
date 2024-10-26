{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    starship
    fzf
    zellij
    bat
    lsd
    bun
  ];

  environment.variables = {
    EDITOR = "nvim";
    SHELL = pkgs.fish;
  };

  programs.fish.loginShell = true;

  # Crear enlaces simbólicos desde ~/dotfiles hacia ~/.config.
  home.file.".config/nvim".source = ~/dotfiles/nvim;
  home.file.".config/fish".source = ~/dotfiles/fish;
  home.file.".config/starship.toml".source = ~/dotfiles/starship/starship.toml;
}
