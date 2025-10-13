# env.nu — Nushell Environment Configuration
# version = "0.107.0"
# ------------------------------------------------------------------------------
# Este archivo define las variables de entorno, PATHs y scripts de inicialización.
# Se carga antes de config.nu
# ------------------------------------------------------------------------------

use std "path add"

# --- Variables globales ---
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# --- Directorios base ---
$env.BUN_INSTALL = ($nu.home-path | path join ".bun")
$env.PNPM_HOME   = ($nu.home-path | path join ".local" "share" "pnpm")

# --- PATH global ---
# Herramientas personales
path add ($nu.home-path | path join "bin")
path add ($nu.home-path | path join ".local" "bin")

# Runtimes / Gestores
path add ($nu.home-path | path join ".volta" "bin")
path add ($env.BUN_INSTALL | path join "bin")
path add ($nu.home-path | path join ".opencode" "bin")
path add $env.PNPM_HOME

# --- Go setup ---
# Detecta si Go está instalado y configura GOPATH y PATH

# Definir una variable temporal para el resultado de `which go`
let go_result = (which go)

# Comprobar si `which_go_result` es null (si el comando no se encontró)
#if ($go_result | is-empty) {
    # Determinar GOPATH dinámicamente
 #   let gopath_raw = (go env GOPATH)
  #  let gopath = ($gopath_raw | str trim)

    # Exportar variables de entorno de forma persistente
   # export-env {
    #    $env.GOPATH = $gopath
     #   $env.GOBIN  = ($gopath | path join "bin")
    #}

    # Agregar binarios de Go al PATH (solo si existe el directorio)
    #let go_bin_path = ($gopath | path join "bin")
    #if ($go_bin_path | path exists) {
        # 'path add' es un comando estándar de NuShell
     #   use std "path add"
     #   path add $go_bin_path
    #}

    # Agregar /usr/local/go/bin si existe (instalación del sistema)
    #if ("/usr/local/go/bin" | path exists) {
    #    use std "path add"
    #    path add "/usr/local/go/bin"
    #}
#}

# # --- Go ---
# if (which go | is-empty | not) {
#     let gopath_raw = ^go env GOPATH
#     let gopath = ($gopath_raw | str trim)
#     if ($gopath | path exists) {
#         path add ($gopath | path join "bin")
#     }
# }
if ($nu.os-info.name == "linux") {
    path add "/usr/local/go/bin"
}

# --- Homebrew ---
if ($nu.os-info.name == "linux") and ("/home/linuxbrew/.linuxbrew/bin/brew" | path exists) {
    path add "/home/linuxbrew/.linuxbrew/bin"
}
if ($nu.os-info.name == "macos") and ("/opt/homebrew/bin/brew" | path exists) {
    path add "/opt/homebrew/bin"
}

# --- Google Cloud SDK (opcional) ---
if ("/usr/local/share/google-cloud-sdk/bin" | path exists) {
    path add "/usr/local/share/google-cloud-sdk/bin"
}

# --- Inicialización de herramientas ---
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu
