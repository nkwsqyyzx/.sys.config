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
        *)
            echo "Usage:add [column]"
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
