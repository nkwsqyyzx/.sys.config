# function setting locales
function gbk() {
    export set LC_ALL=zh_CN.GBK
    export set LANG=zh_CN.GBK
    export set OUTPUT_CHARSET=GBK
    export set set LESSCHARSET=latin1
}

function unicode() {
    export set LC_ALL=Unicode
    export set LANG=Unicode
    export set LESSCHARSET=Unicode
}

function utf8() {
    export set LC_ALL=en.UTF-8
    export set LANG=en.UTF-8
    export set OUTPUT_CHARSET=zh_CN.GBK
    export set LESSCHARSET=latin1
}

function utf16() {
    export set LC_ALL=en.UTF-16
    export set LANG=en.UTF-16
    export set OUTPUT_CHARSET=UTF-8
    export set LESSCHARSET=latin1
}

function web() {
    export set LC_ALL=en_US.UTF-16
    export set LANG=en_US.UTF-16
    export set XMODIFIERS=@im=Chinput3
    stty cs8 -istrip
    stty pass8
    export set LESSCHARSET=latin1
}

function myencoding() {
    export set LC_CTYPE=zh_CN.UTF-8
    export set LANG=en_US.UTF-8
    export set XMODIFIERS=@im=Chinput3
    stty cs8 -istrip
    stty pass8
    export set LESSCHARSET=UTF-8
}

function perfect() {
    export set LANG=zh_CN.UTF-16@cjkwide
    export set LC_CTYPE=zh_CN.UTF-16@cjkwide
    export set XMODIFIERS=@im=Chinput3
    stty cs8 -istrip
    stty pass8
    export set LESSCHARSET=UTF-8
}

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
