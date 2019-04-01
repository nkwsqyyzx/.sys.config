function column() {
    local key_column_indexes=()
    local awk_args=""
    local remain=""
    while [[ "$1" != "" ]]; do
        case $1 in
            -F*)
            awk_args="$1"
            ;;
            -r)
            shift
            remain="$1"
            p=""
            ;;
            -p)
            shift
            awk_args="$1"
            p=""
            ;;
            -k)
            shift
            p=key
            key_column_indexes+=("$1")
            ;;
            -h|help)
            echo "column [-k] column1 [column2...] -p \"AWK_ARGS\" -r \"INPUT_FILE\""
            kill -INT $$
            ;;
            *)
            key_column_indexes+=("$1")
            ;;
        esac
        shift
    done

    awk_cmd=$(call_python_function.py ~/.sys.config/py/tools/ awk.Tool.column "$key_column_indexes" "$awk_args" "$remain")
    eval "${awk_cmd}"
}

function ncolumn() {
    PYTHON_CMD=$(cat <<EOF
args = '$*'.split(' ')
awk_args = []
fields = []
remain = []
for (index, arg) in enumerate(args):
    if arg.startswith('-'):
        awk_args.append("{}'{}'".format(arg[0:2], arg[2:]))
        continue
    if not arg.isdigit():
        remain = args[index:]
        break
    fields.append(arg)
v_list = ' '.join(['-v c{}={}'.format(i, v) for (i, v) in enumerate(fields)])
p_list = '; '.join(['\$c{}=""'.format(i) for i in range(0, len(fields))])
p_args = '{' + p_list + '; print}'
r_args = ' '.join(remain)
awk_args = ' '.join(awk_args)
print("awk {} {} '{}' {}".format(awk_args, v_list, p_args, r_args))
EOF
)
    awk_cmd=$(python -c "$PYTHON_CMD")
    eval "${awk_cmd}"
}

function add() {
    case $# in
        0)
        awk '{s+=$1} END {print s}'
        ;;
        1)
        awk -v c1=$1 '{s+=$c1} END {print s}'
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
        echo "Usage:add [column1...]"
        ;;
    esac
}

function average() {
    case $# in
        0)
        awk '{c+=1; s+=$1} END {print s/c}'
        ;;
        1)
        awk -v c1=$1 '{c+=1; s+=$c1} END {print s/c}'
        ;;
        *)
            echo "Usage:average [column]"
        ;;
    esac
}

function count_group_by() {
    case $# in
        0)
        awk '{s[$0] += 1} END { for (i in s) {print i "\t" s[i]} }'
        ;;
        1)
        awk -v c1=$1 '{s[$c1] += 1} END { for (i in s) {print i "\t" s[i]} }'
        ;;
        2)
        awk -v c1=$1 -v c2=$2 '{s[$c1"\t"$c2] += 1} END { for (i in s) {print i "\t" s[i]} }'
        ;;
        3)
        awk -v c1=$1 -v c2=$2 -v c3=$3 '{s[$c1"\t"$c2"\t"$c3] += 1} END { for (i in s) {print i "\t" s[i]} }'
        ;;
        *)
        echo "Usage:count_group_by [group_key]"
        ;;
    esac
}

function sum_group_by() {
    local key_column_indexes=()
    local value_column_indexes=()
    local awk_args=""
    local remain=""
    local p=""
    while [[ "$1" != "" ]]; do
        case $1 in
            -F*)
            awk_args="$1"
            ;;
            -r)
            shift
            remain="$1"
            p=""
            ;;
            -p)
            shift
            awk_args="$1"
            p=""
            ;;
            -k)
            shift
            p=key
            key_column_indexes+=("$1")
            ;;
            -v)
            shift
            p=value
            value_column_indexes+=("$1")
            ;;
            -h|help)
            echo "sum_group_by -k column [column] -v column [column] -p \"AWK_ARGS\" -r \"INPUT_FILE\""
            kill -INT $$
            ;;
            *)
            case ${p} in
            key)
            key_column_indexes+=("$1")
            ;;
            value)
            value_column_indexes+=("$1")
            ;;
            esac
            p=""
            ;;
        esac
        shift
    done

    local awk_cmd=$(call_python_function.py ~/.sys.config/py/tools/ awk.Tool.sum_group_by "$key_column_indexes" "$value_column_indexes" "$awk_args" "$remain")
    eval "${awk_cmd}"
}
