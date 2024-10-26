{ config, pkgs, ... }:

{
  # Habilitar Fish como shell por defecto.
  programs.fish = {
    enable = true;
    loginShell = true;
  };

  # Instalar los paquetes necesarios.
  environment.systemPackages = with pkgs; [
    git
    gh            # CLI de GitHub.
    wget
    fish
    neovim
    fzf
    zellij
    bat
    lsd
    bun           # Administrador de paquetes.
    starship      # Prompt personalizado.
    nodejs        # Node.js y npm.
    yarn
    typescript
  ];

  # Establecer variables de entorno.
  environment.variables = {
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

  # Cambiar el shell predeterminado a Fish (WSL necesita ajuste manual).
  home.activation.setFishShell = lib.mkAfter ''
    if ! grep -q "$(which fish)" /etc/shells; then
      which fish | sudo tee -a /etc/shells
    fi
    chsh -s "$(which fish)"
  '';
}
