# 存储一些常用的小工具
function send_wechat_robot_text() {
    local secret=$(jq -r '.info.secret' <~/.config/robot_wechat.json)
    call_python_function.py ~/.sys.config/py/tools wechat.robot_send_text $secret "$*"
}
