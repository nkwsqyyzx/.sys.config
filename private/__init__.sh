# 只加载sh结尾的文件
for f in "${_CONFIG_BASE}"/private/[a-z]*.sh; do
    if [[ -f "${f}" ]]; then
        source "${f}"
    fi
done

export PATH="$PATH":"${_CONFIG_BASE}/private/"
