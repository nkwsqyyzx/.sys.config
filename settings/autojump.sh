# autojump: source profile.d 脚本以注册 j 命令 (跳目录)
# 按 platform + 安装方式试多个候选路径, 命中第一个即停
for _aj_path in \
    /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh \
    /opt/homebrew/etc/profile.d/autojump.sh \
    /usr/local/etc/profile.d/autojump.sh \
    "$HOME/.autojump/etc/profile.d/autojump.sh"; do
    if [[ -f "$_aj_path" ]]; then
        source "$_aj_path"
        break
    fi
done
unset _aj_path
