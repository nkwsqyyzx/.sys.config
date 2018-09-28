export AUTOJUMP_WEIGHT_FILE="$(type j 1>/dev/null 2>/dev/null && j -s | tail -1 | column 2)"

function _print_selected_dir() {
    if [[ -r "${AUTOJUMP_WEIGHT_FILE}" ]]; then
        if [[ -z "${AUTOJUMP_WEIGHT_FILE_LINES}" ]]; then
            export AUTOJUMP_WEIGHT_FILE_LINES=$(wc -l "${AUTOJUMP_WEIGHT_FILE}"|column 1)
        fi
        sort -nr "${AUTOJUMP_WEIGHT_FILE}" | head -n $((${AUTOJUMP_WEIGHT_FILE_LINES}/3)) | column -F'\t' 2 | fzf +s
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
