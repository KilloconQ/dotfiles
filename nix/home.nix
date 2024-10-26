{ config, pkgs, ... }:

{
  # Habilitar Fish como shell por defecto.
  programs.fish = {
    enable = true;
    loginShell = true;
  };

  # Paquetes adicionales.
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

  # Variables de entorno.
  environment.variables = {
    EDITOR = "nvim";
    SHELL = pkgs.fish;
  };

  # Eliminar cualquier carpeta conflictiva antes de crear los symlinks.
  home.activation.cleanFishConfig = let
    script = ''
      rm -rf ~/.config/fish   # Elimina la carpeta conflictiva si existe.
      ln -sfn ~/dotfiles/fish ~/.config/fish  # Crea el symlink.
    '';
  in {
    run = script;
  };

  # Otros enlaces simbólicos.
  home.file.".config/nvim".source = ~/dotfiles/nvim;
  home.file.".config/zellij".source = ~/dotfiles/zellij;
  home.file.".wezterm.lua".source = ~/dotfiles/wezterm/.wezterm.lua;
  home.file.".config/omf".source = ~/dotfiles/omf;
  home.file.".config/starship.toml".source = ~/dotfiles/starship/starship.toml;

  # Instalar Oh My Fish.
  home.activation.installOMF = let
    omfScript = ''
      curl -L https://get.oh-my.fish | fish
      omf install pj
    '';
  in {
    run = omfScript;
  };
}
