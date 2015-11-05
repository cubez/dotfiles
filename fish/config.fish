# Greeting on new terminal
set -e fish_greeting

# Fish colors and escape codes
set fish_color_autosuggestion FFC473
set fish_color_command FF9400
set fish_color_comment A63100
set fish_color_cwd green
set fish_color_cwd_root red
set fish_color_end FF4C00
set fish_color_error FFDD73
set fish_color_escape cyan
set fish_color_history_current cyan
set fish_color_host \x2do\x1ecyan
set fish_color_match cyan
set fish_color_normal normal
set fish_color_operator cyan
set fish_color_param FFC000
set fish_color_quote BF9C30
set fish_color_redirection BF5B30
set fish_color_search_match \x2d\x2dbackground\x3dpurple
set fish_color_selection \x2d\x2dbackground\x3dpurple
set fish_color_status red
set fish_color_user \x2do\x1egreen
set fish_color_valid_path \x2d\x2dunderline
set fish_greeting \x1d
set fish_key_bindings fish_default_key_bindings
set fish_pager_color_completion normal
set fish_pager_color_description 555\x1eyellow
set fish_pager_color_prefix cyan
set fish_pager_color_progress cyan

function fish_prompt
    set last_status $status
    
    set user (whoami)

    set_color magenta
    printf '%s' $user
    set_color normal
    printf '@'

    set_color yellow
    printf '%s' (hostname -s)
    set_color normal
    printf ' in '

    set_color $fish_color_cwd
    printf '%s' (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')
    set_color normal

    if test $last_status -ne 0
        set_color white -o
        printf '[%d] ' $last_status
        set_color normal
    end
    printf ' $ '

    set_color normal
end

function docker-clean
	docker rmi (docker images --filter dangling=true --quiet)
	docker rm (docker ps -a | grep Exited | cut -d" " -f1)
end