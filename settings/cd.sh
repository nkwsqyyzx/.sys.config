export AUTOJUMP_WEIGHT_FILE="$(type autojump 1>/dev/null 2>/dev/null && autojump -s | tail -1 | awk '{print $2}')"

function _print_selected_dir() {
    if [[ -r "${AUTOJUMP_WEIGHT_FILE}" ]]; then
        sort -nr "${AUTOJUMP_WEIGHT_FILE}" | awk -F"\t" '{print $2}' | fzf +s
    fi
}

function _bash_enter_selected_dir() {
    local dir
    dir=$(_print_selected_dir)
    if [[ -n "${dir}" ]]; then
        cd "${dir}"
    fi
}

if [[ "x${SHELL_TYPE}" = "xbash" ]]; then
    bind -x '"\C-X\C-X":"_bash_enter_selected_dir"'
fi

type -a autojump 1>/dev/null 2>/dev/null || echo "You should configure autojump, in mac, use:\nbrew install autojump"
type -a fzf 1>/dev/null 2>/dev/null || echo "You should configure fzf, in mac, use:\nbrew install fzf"
