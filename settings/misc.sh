alias mk_password="echo $(openssl rand -base64 16 | head -c 16)"
alias vic="vim -R -c 'execute \"silent !echo \" . &fileencoding | q'"
function setjdk() {
    if [ $# -ne 0 ]; then
        export JAVA_HOME=`/usr/libexec/java_home -v $@`
        export PATH=$JAVA_HOME/bin:$PATH
    fi
}

function vps_download() {
    if [ $# -ne 2 ]; then
        echo "Usage:vps_download user@your_own_vps your_url"
        kill -INT $$
    fi
    local name=$(echo "$2" | sed "s/.*\///g" | sed 's/[^a-zA-Z0-9\.\-]/0/g')
    ssh $1 -t "(cd /tmp;rm -rf $name;wget -O $name $2)"
    scp $1:"/tmp/$name" "$name"
}

function ln_log() {
    /bin/ls -alt|column 9|grep '[0-9]\{1,\}$'|sed 's/\.[0-9]\+$//'|sort|uniq|while read -r link; do
        local log=$(/bin/ls -alt "$link."[0-9]*|column 9|grep '[0-9]\{1,\}'|head -n 1)
        echo "$log"
        if [[ -L "$link" ]]; then
            real=$(readlink "$link")
            if [[ ! "x$real" == "x$log" ]]; then
                rm -rf "$link"
            fi
        fi
        if [[ ! -f "$link" ]]; then
            ln -s "$log" "$link"
        fi
    done
}

function refresh_log() {
    while sleep 60; do
        ln_log
    done
}

function url_encode() {
    cat <<EOF | python3 - "$*"
import sys
import urllib.parse

print(urllib.parse.quote(sys.argv[1]))
EOF
}

function url_decode() {
    cat <<EOF | python3 - "$*"
import sys
import urllib.parse

print(urllib.parse.unquote(sys.argv[1]))
EOF
}

function base64_decode() {
    if [ $# -ne 1 ]; then
        echo "Usage:base64_decode your_base64_encoded_string"
        kill -INT $$
    fi
    if which jq 1>/dev/null; then
        python -m base64 -d <<<"$1" | jq .
    else
        python -m base64 -d <<<"$1"
    fi
}

function base64_encode() {
    if [ $# -ne 1 ]; then
        echo "Usage:base64_encode your_string"
        kill -INT $$
    fi
    python -m base64 <<<"$1"
}

function pj() {
    local fname=""
    local origin=""
    while getopts ":i:" o; do
        case "${o}" in
            i)
                origin="$OPTARG"
                fname="$(date|sed 's/[^0-9]//g')_back"
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [[ -z "$origin" ]]; then
        origin="$1"
    fi
    if [[ -n "$fname" ]]; then
        /usr/bin/env pj "$origin" >"$fname" && mv "$fname" "$origin"
    else
        if [[ -n "$origin" ]]; then
            /usr/bin/env pj "$origin"
        else
            /usr/bin/env pj
        fi
    fi
}

function ajap() {
    local fname=""
    local origin=""
    while getopts ":i:" o; do
        case "${o}" in
            i)
                origin="$OPTARG"
                fname="$(date|sed 's/[^0-9]//g')_back"
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [[ -z "$origin" ]]; then
        origin="$1"
    fi
    if [[ -n "$fname" ]]; then
        /usr/bin/env ajap <"$origin">"$fname" && mv "$fname" "$origin"
    else
        if [[ -n "$origin" ]]; then
            /usr/bin/env ajap <"$origin"
        else
            /usr/bin/env ajap
        fi
    fi
}
