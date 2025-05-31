function code
    bash -c "code $argv"
end
#
##  yazi

function ya_zed
    set tmp (mktemp -t "yazi-chooser.XXXXXXXXXX")
    yazi --chooser-file $tmp $argv

    if test -s $tmp
        set opened_file (head -n 1 -- $tmp)
        if test -n "$opened_file"
            if test -d "$opened_file"
                # Es una carpeta, la agregamos al workspace
                zed --add "$opened_file"
            else
                # Es un archivo, lo abrimos normalmente
                zed --add "$opened_file"
            end
        end
    end

    rm -f -- $tmp
end
