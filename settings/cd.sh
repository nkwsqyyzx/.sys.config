export AUTOJUMP_WEIGHT_FILE="$(type autojump 1>/dev/null 2>/dev/null && autojump -s | tail -1 | awk '{print $2}')"

function _print_selected_dir() {
    if [[ -r "${AUTOJUMP_WEIGHT_FILE}" ]]; then
        if [[ -z "${AUTOJUMP_WEIGHT_FILE_LINES}" ]]; then
            local lines=$(wc -l "${AUTOJUMP_WEIGHT_FILE}"|awk '{print $1}')
            lines="$((${lines}/2))"
            if [[ ${lines} -lt 100 ]]; then
                lines=100
            fi
            export AUTOJUMP_WEIGHT_FILE_LINES=${lines}
        fi
        sort -nr "${AUTOJUMP_WEIGHT_FILE}" | head -n $((${AUTOJUMP_WEIGHT_FILE_LINES})) | awk -F"\t" '{print $2}' | fzf +s
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
