# Variables de entorno y detección del sistema
set -gx OS_TYPE (uname)
set IS_WSL false
if uname -r | grep -qi microsoft
    set IS_WSL true
end

set -gx PATH /usr/local/bin /home/linuxbrew/.linuxbrew/bin $PATH
