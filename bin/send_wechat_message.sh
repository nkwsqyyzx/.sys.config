#!/bin/bash

message="$1"

function fail_with_zero() {
    echo "$*"
    exit 0
}

function fail_with_non_zero() {
    echo "$*"
    exit 1
}

[[ -z "${message}" ]] && fail_with_non_zero "line $LINENO, no message!!!"

corp_id=$(grep '^corp_id=' ~/.config/wechat.conf | awk -F'=' '{print $2}')
corp_secret=$(grep '^corp_secret=' ~/.config/wechat.conf | awk -F'=' '{print $2}')

touser=$(grep '^touser=' ~/.config/wechat.conf | awk -F'=' '{print $2}')
agent_id=$(grep '^agent_id=' ~/.config/wechat.conf | awk -F'=' '{print $2}')

[[ -z "${corp_id}" ]] && fail_with_non_zero "line $LINENO, bad conf"
[[ -z "${corp_secret}" ]] && fail_with_non_zero "line $LINENO, bad conf"
[[ -z "${touser}" ]] && fail_with_non_zero "line $LINENO, bad conf"
[[ -z "${agent_id}" ]] && fail_with_non_zero "line $LINENO, bad conf"

function refresh_token() {
    res=$(call_python_function.py ~/.sys.config/py/tools wechat.Tool.update_access_token "${corp_id}" "${corp_secret}")
    if [[ -n "${res}" ]]; then
        echo "${res}" > ~/.config/wechat.token
        echo "token refreshed"
    else
        echo "refresh token failed"
    fi
}

if [[ ! -f ~/.config/wechat.token ]]; then
    refresh_token
fi
access_token=$(cat ~/.config/wechat.token)

function send_message() {
    call_python_function.py ~/.sys.config/py/tools wechat.Tool.send_text_to_user "${access_token}" "${agent_id}" "${touser}" "${message}"
}

res=$(send_message)
echo "${res}" | grep 'access_token expired' && (refresh_token && access_token=$(cat ~/.config/wechat.token) && send_message)
