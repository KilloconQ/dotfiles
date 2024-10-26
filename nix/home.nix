{ config, pkgs, lib, ... }:

{
  # Definir el nombre de usuario para Home Manager.
  home.username = "killoconq";  # Cambia según corresponda.
  home.homeDirectory = "/home/killoconq";  # Asegúrate de que esta ruta sea correcta.
  home.stateVersion = "23.05";  # Asegúrate de que coincide con la versión que usas.

  # Habilitar Fish como shell por defecto.
  programs.fish.enable = true;

  # Configuración para cambiar el shell predeterminado a Fish.
  home.activation.setFishShell = lib.mkAfter ''
    if ! grep -q "$(which fish)" /etc/shells; then
      which fish | sudo tee -a /etc/shells
    fi
    chsh -s "$(which fish)"
  '';

  # Instalar los paquetes necesarios.
  home.packages = with pkgs; [
    git
    gh
    wget
    fish
    neovim
    fzf
    zellij
    bat
    lsd
    bun
    starship
    nodejs
    yarn
    typescript
  ];

  # Establecer variables de entorno.
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = pkgs.fish;
  };

  # Crear enlaces simbólicos automáticamente.
  home.file.".config/nvim".source = ~/dotfiles/nvim;
  home.file.".config/zellij".source = ~/dotfiles/zellij;
  home.file.".wezterm.lua".source = ~/dotfiles/wezterm/.wezterm.lua;
  home.file.".config/fish".source = ~/dotfiles/fish;
  home.file.".config/omf".source = ~/dotfiles/omf;
  home.file.".config/config".source = ~/dotfiles/config;
  home.file.".config/starship.toml".source = ~/dotfiles/starship/starship.toml;

  # Plugins de Oh My Fish.
  home.activation.installOmfPlugins = lib.mkAfter ''
    curl -L https://get.oh-my.fish | fish
    omf install pj
  '';
}
