# 只加载sh结尾的文件
find "${_CONFIG_BASE}/autoload/" -type f -name "[a-z]*.sh"|while read -r f; do
    if [[ -f "${f}" ]]; then
        source "${f}"
    fi
done

export PATH="$PATH":"${_CONFIG_BASE}/autoload/"
