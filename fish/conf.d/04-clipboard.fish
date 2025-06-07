# Define fish_clipboard_paste según el sistema

if test "$OS_TYPE" = Darwin
    function fish_clipboard_paste
        set text (pbpaste)
        commandline -i $text
    end

else if test "$IS_WSL" = true
    function fish_clipboard_paste
        set text (xclip -o -selection clipboard)
        commandline -i $text
    end

else if test "$XDG_SESSION_TYPE" = wayland
    function fish_clipboard_paste
        set text (wl-paste)
        commandline -i $text
    end

else
    function fish_clipboard_paste
        set text (xclip -o -selection clipboard)
        commandline -i $text
    end
end

##  yazi

function ya_zed
    set tmp (mktemp -t "yazi-chooser.XXXXXXXXXX")
    yazi --chooser-file $tmp $argv
    if test -s $tmp
        set opened_file (head -n 1 -- $tmp)
        if test -n "$opened_file"
            zed -- "$opened_file"
        end
    end
    rm -f -- $tmp
end
