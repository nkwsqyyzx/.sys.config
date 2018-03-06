function column() {
    case $# in
        1)
        awk -v c1=$1 '{print $c1}'
        ;;
        2)
        awk -v c1=$1 -v c2=$2 '{print $c1, $c2}'
        ;;
        3)
        awk -v c1=$1 -v c2=$2 -v c3=$3 '{print $c1, $c2, $c3}'
        ;;
        4)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 '{print $c1, $c2, $c3, $c4}'
        ;;
        5)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 '{print $c1, $c2, $c3, $c4, $c5}'
        ;;
        6)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 '{print $c1, $c2, $c3, $c4, $c5, $c6}'
        ;;
        7)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 '{print $c1, $c2, $c3, $c4, $c5, $c6, $c7}'
        ;;
        8)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 -v c8=$8 '{print $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8}'
        ;;
        9)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 -v c8=$8 -v c9=$9 '{print $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9}'
        ;;
        *)
            echo "Usage:col column [column ...]"
        ;;
    esac
}

function add() {
    case $# in
        0)
        awk '{sum+=$1} END {print sum}'
        ;;
        1)
        awk -v c1=$1 '{sum+=$c1} END {print sum}'
        ;;
        2)
        awk -v c1=$1 -v c2=$2 '{s1+=$c1; s2+=$c2} END {print s1, s2}'
        ;;
        3)
        awk -v c1=$1 -v c2=$2 -v c3=$3 '{s1+=$c1; s2+=$c2; s3+=$c3} END {print s1, s2, s3}'
        ;;
        4)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4} END {print s1, s2, s3, s4}'
        ;;
        5)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4; s5+=$c5} END {print s1, s2, s3, s4, s5}'
        ;;
        6)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c5=$5 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4; s5+=$c5; s6+=$c6} END {print s1, s2, s3, s4, s5, s6}'
        ;;
        7)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4; s5+=$c5; s6+=$c6; s7+=$c7} END {print s1, s2, s3, s4, s5, s6, s7}'
        ;;
        8)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 -v c8=$8 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4; s5+=$c5; s6+=$c6; s7+=$c7; s8+=$c8} END {print $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8}'
        ;;
        9)
        awk -v c1=$1 -v c2=$2 -v c3=$3 -v c4=$4 -v c5=$5 -v c6=$6 -v c7=$7 -v c8=$8 -v c9=$9 '{s1+=$c1; s2+=$c2; s3+=$c3; s4+=$c4; s5+=$c5; s6+=$c6; s7+=$c7; s8+=$c8; s9+=$c9} END {print $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8, $s9}'
        ;;
        *)
        echo "Usage:add [column1] [column2] [column3] [column4] [column5]"
        ;;
    esac
}

function average() {
    case $# in
        0)
        awk '{count+=1; sum+=$1} END {print sum/count}'
        ;;
        1)
        awk -v c1=$1 '{count+=1; sum+=$c1} END {print sum/count}'
        ;;
        *)
            echo "Usage:average [column]"
        ;;
    esac
}

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
    local name=$(echo "$2" | sed "s/.*\///g")
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
