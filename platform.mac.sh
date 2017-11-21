alias o='open'
alias ou='open'
alias ll='ls -alG'
alias ip="ifconfig | sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk '{print \$2}'"

export DIFFMERGE_EXE=/Applications/DiffMerge.app/Contents/MacOS/DiffMerge

function proxy() {
    case "$1" in
    on)
        sudo networksetup -setsocksfirewallproxystate Wi-Fi on
        ;;
    off)
        sudo networksetup -setsocksfirewallproxystate Wi-Fi off
        ;;
    set)
        local domain="$2"
        local port="$3"
        if [ -z "$domain" ] || [ -z "$port" ]; then
            echo "Usage: proxy set domain port"
        else
            sudo networksetup -setsocksfirewallproxy Wi-Fi "$domain" "$port"
                fi
                ;;
    status|st)
        networksetup -getsocksfirewallproxy Wi-Fi
        ;;
    *)
        echo "Usage: proxy {on|off|set|status}"
        ;;
    esac
}

function proxy_auto() {
    case "$1" in
    on)
        sudo networksetup -setautoproxystate Wi-Fi on
        ;;
    off)
        sudo networksetup -setautoproxystate Wi-Fi off
        ;;
    set)
        local domain="$2"
        if [ -z "$domain" ]; then
            echo "Usage: proxy set domain port"
        else
            sudo networksetup -setautoproxyurl Wi-Fi "$domain"
        fi
        ;;
    status|st)
        networksetup -getautoproxyurl Wi-Fi
        ;;
    *)
        echo "Usage: proxy_auto {on|off|set|status}"
        ;;
    esac
}

function ow() {
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcodeproj 2>&1 1>/dev/null; then
            for i in *.xcodeproj; do open "$i"; done
        else
            echo "ERROR, xcode project not exists in '$(pwd)' !"
            echo "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

[[ -L "$_CONFIG_BASE"/bin/gvim ]] || (cd "$_CONFIG_BASE"/bin/;ln -s mac_vim_startup_script gvim)

function _qrcode() {
    local fname="$(date|sed 's/[^0-9]//g')"
    qrcode "$1" > $fname.png && o $fname.png && (sleep 1 && rm $fname.png)
}

alias qrcode='_qrcode'

function clearStupidLogs() {
    # xcode related files
    find ~/Library/Developer/Xcode/DerivedData -type d -mtime +10 -depth 1 | xargs rm -rf
    # AndroidStudio related logs
    find ~/Library/Logs/AndroidStudio* -type f -mtime +2 | xargs rm -rf
    # logs such as idea related files
    find ~/Library/Logs -type f -mtime +2 | xargs rm -rf
}
