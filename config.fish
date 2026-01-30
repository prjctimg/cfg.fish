#! /usr/bin/env fish

bind \ea opencode
bind \ee nvim

bind \et btop
bind \ex "cd -"
bind \eh "invoke_bash 'x --help'"
bind \e\x20 yazi
bind \ef flow
bind \e/ fzf
# options
fish_default_key_bindings
# fish_vi_key_bindings
function wk

    cd $HOME/workspace/

end

function x
    x-cmd $argv

end


function chssh_key --description="Change the passphrase for SSH key"


    ssh-keygen -p -f .ssh/id_ed25519


end

function zigfmt

    zig fmt $argv

end


function cron

    crontab $argv
end
function rc
    cd $HOME/sources/

end


function xx

    exit 0
end


function vig
    nvim $HOME/.config/ghostty/config

end

function ai
    crush $argv
end

function typr --description="Open MonkeyType in the browser"

    cd $HOME/sources/monkeytype/


    sudo docker-compose up -d
    chrome http://localhost:8080
    cd ~
end
function vif
    vi $HOME/.config/fish/ $argv


end



function kill_typr --description="Kill the Monkeytype Docker container (typr)"

    sudo docker ps -q | xargs -r sudo docker stop


end


function time_greeting
    set hour (date +"%H")
    set name $(whoami)
    if test $hour -ge 5 -a $hour -lt 12
        set greeting "Good morning, $name ☀️"
    else if test $hour -ge 12 -a $hour -lt 17
        set greeting "Good afternoon, $name 🌤️"
    else if test $hour -ge 17 -a $hour -lt 21
        set greeting "Good evening, $name 🌆"
    else
        set greeting "What is sleep, $name? 🌙"
    end

    printf (set_color blue)"%s"(set_color normal)"\n" "$greeting"

end
function daily_verse
    # Define the path to your verses JSON file.
    # You might want to adjust this path based on where you saved the file.
    set -l verse_file "$HOME/.config/fish/verses.json"

    set -l day_of_month (date +%d | sed 's/^0*//' | string trim)
    set -l index (math "$day_of_month" - 1)
    # Ensure the file exists before trying to read it
    if not test -f "$verse_file"
        return
    end

    set -l current_hour (date +%H)


    # Use 'jq' to read the JSON file, get the current day of the month,
    # and use it as an index to pick a verse.

    # Use 'jq' to extract the verse at the calculated index
    set -l verse (jq -r ".[$index % length].text" < "$verse_file")

    set -l verse_ref (jq -r ".[$index % length].reference" < "$verse_file")
    # Print the verse, with some styling

    if test $current_hour -lt 12
        echo $(random choice "🌅" "🌄" "🍃" )
    else if test $current_hour -lt 18
        echo $(random choice "🏙️" "🏖️" )
    else
        echo $(random choice "🌆" "🌇"  "🌃" "🌉")
    end
    # printf (set_color green)"Day $day_of_month\n\n"(set_color normal)

    echo ""
    printf (set_color cyan)"%s"(set_color normal)"\n" "$verse"

    echo ""
    printf (set_color blue)"%s"(set_color normal)"\n" "📜 $verse_ref"

end

function dashboard_greeter_nvim

    set options square alpha crunchbang-mini six fade suckless
    while true
        set choice $options[(math (random) % (count $options) + 1)]
        colorscript -e $choice | pv -qL 80 | lolcat -at
        sleep 6
        clear
    end
end

function fish_greeting


    time_greeting | pv -qL 70

end


## Run the specified module. Supports Zig, JS/TS, Fish/Bash, Lua and Python.

function run --description="Run a script. It will pick the program based on the extension."


    if not set -q argv[1]

        echo "Usage $0 <file>"
        exit 1
    end

    set file $argv[1]
    set ext (echo $file | awk -F '.' '{print $NF}')


    if test "$ext" = "$file"
        if not test -x $file
            echo "File not executable."
            chmod +x $file
            echo "File made executable. Running it..."
            $file
        else
            $file

        end
    else
        switch $ext
            case lua

                lua $file

            case js ts mts mjs cjs


                bun $file


            case sh
                bash $file
            case fish

                fish $argv $file
            case zig

                zig run $file $argv
        end
    end
end
function vicron --description="Modify the cron scripts inside Neovim"
    vi $HOME/.config/.routines/
end


function manx

    invoke_bash "x --help"

end
function lsx --description="Like the ls command but supercharged"

    invoke_bash "x ls $argv"
end


# Source the configuration files
function so

    # @fish-lsp-disable-next-line 1004
    source /home/$(whoami)/.config/fish/config.fish
end

function invoke_bash
    bash -ci $argv
end


function rm

    command sudo rm -rfv $argv

end

function cdd --description="View directories as you change into them"
    if not has_args $argv
        cd $argv
    else
        echo 'Change to path📁 directory'
        invoke_bash " x cd $argv"
    end
end


function agg --description="Convert terminal session recordings to GIF"

    for cast in $argv
        command agg $cast gif/$cast.gif
    end
end



function see --description="See an image in the terminal (requires Viu/chafa)"

    viu $argv


end

function has_args
    set len $(count $argv)
    test $len -eq 0
end

function to --description="Alias for the touch command"

    touch $argv

end

function git
    x git $argv
end

function obsidian
    command obsidian --disable-gpu

end




function ls

    lsd $argv
end



function lsp --description="List the PATH"
    invoke_bash "x path $argv"
end


function mtrx
    tr -c "[:digit:]" " " </dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1
32" grep --color "[^ ]"

end

function chrome --description="Launch the Chrome browser"
    garcon-url-handler --client $argv
end


function vi
    nvim $argv
end




function mv
    command mv -v $argv

end

function cp
    command cp $argv -rvf

end



function du
    command du -sh $argv

end



function add-pkg --description="Add package(s) using Nala"
    sudo nala install $argv
end


function rm-pkg --description="Remove package(s) using Nala"
    sudo nala remove $argv && sudo nala clean

end

function top
    btop $argv

end


function odin
    /usr/bin/odin-linux-arm64-nightly+2025-10-09/odin $argv

end



function tree --description="Show the top level directory structure"
    lsd -td --tree $argv
end

function cfg
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv

end

set -x EDITOR nvim
set -x MYVIMRC "$XDG_CONFIG_HOME/nvim-minimax/"
set -x TERMRC "$XDG_CONFIG_HOME/ghostty/config"
set -x GHOSTTY_SHELL_INTEGRATION_NO_SUDO 0
set -x PATH //home/prjctimg/.bun/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/go/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/.x-cmd.root/bin:/home/prjctimg/.cargo/bin/:/usr/local/go/bin/:/home/prjctimg/.juliaup/bin/:/home/prjctimg/.local/share/nvim/mason/bin/:/home/prjctimg/.zvm/bin:/home/prjctimg/.zvm/self
set -x SHELL fish
set -x SUDO_EDITOR $(which nvim)
set -x OPENSSL_DIR $(which openssl)

carapace _carapace | source




eval (starship init fish)
ssh_agent
