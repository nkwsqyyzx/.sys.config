alias o='open'
alias ou='open'
alias ll='ls -alG'
alias ip="ifconfig | sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk '{print \$2}'"

export DIFFMERGE_EXE=/Applications/DiffMerge.app/Contents/MacOS/DiffMerge

# Follow this page to avoid enter password
# http://apple.stackexchange.com/questions/236806/prevent-networksetup-from-asking-for-password
function proxy-charles()
{
    sudo networksetup -setwebproxystate Wi-Fi on;
    sudo networksetup -setsecurewebproxystate  Wi-Fi on;
    sudo networksetup -setwebproxy Wi-Fi 127.0.0.1 8888;
    sudo networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 8888;
    sudo networksetup -setautoproxystate Wi-Fi off;
    sudo networksetup -setsocksfirewallproxystate Wi-Fi off;
}

function proxy-google()
{
    sudo networksetup -setwebproxystate Wi-Fi off;
    sudo networksetup -setsecurewebproxystate  Wi-Fi off;
    sudo networksetup -setautoproxystate Wi-Fi on;
    sudo networksetup -setautoproxyurl Wi-Fi http://pac.internal.baidu.com/bdnew.pac;
    sudo networksetup -setsocksfirewallproxystate Wi-Fi off;
}

function proxy()
{
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

function ow()
{
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcodeproj 2>&1 1>/dev/null; then
            for i in *.xcodeproj;open "$i"
        else
            echo "ERROR, xcode project not exists in '$(pwd)' !"
            echo "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

BASEDIR=$(dirname $0)
[[ -L "$BASEDIR"/bin/gvim ]] || (cd "$BASEDIR"/bin/;ln -s mac_vim_startup_script gvim)
