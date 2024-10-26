{ config, pkgs, lib, ... }:

{
  # Definir el nombre de usuario para Home Manager.
  home.username = "killoconq";  # Asegúrate de usar el nombre correcto de tu usuario.

  # Definir la versión del estado de Home Manager.
  home.stateVersion = "23.05";  # Ajusta según la versión de Nixpkgs o Home Manager que uses.

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
  home.file.".config/nvim".source = ./nvim;
  home.file.".config/zellij".source = ./zellij;
  home.file.".wezterm.lua".source = ./wezterm/.wezterm.lua;
  home.file.".config/fish".source = ./fish;
  home.file.".config/omf".source = ./omf;
  home.file.".config/config".source = ./config;
  home.file.".config/starship.toml".source = ./starship/starship.toml;

  # Plugins de Oh My Fish.
  home.activation.installOmfPlugins = lib.mkAfter ''
    curl -L https://get.oh-my.fish | fish
    omf install pj
  '';
}
