function element(d, tag, property, pattern) {
    var a = d.getElementsByTagName(tag);
    var rs = [];
    for (var attr, i = 0, l = a.length; i < l; i++) {
        attr = a[i].getAttribute(property);
        if (attr === undefined)
            continue;
        if (pattern.test(attr))
            rs.push(a[i]);
    }
    return rs;
}

commands.addUserCommand("AdsKill", "kill adds", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    let body = d.body;

    // 内容中的广告
    var c1 = 0;
    var pattern = /(adsbygoogle|show_ads\.js|^http:\/\/pos\.baidu\.com)/;
    var divs = element(d, 'div', 'class', /^entry(-?content)?$/);
    for (i in divs) {
        var div = divs[i];
        var suspect = element(div, 'script', 'src', pattern);
        for (j in suspect) {
            var ad = suspect[j].parentNode;
            ad.remove();
            c1++;
        }
    }

    // 脚本广告
    var c2 = 0;
    var scriptAds = element(d, 'script', 'src', pattern);
    for (i in scriptAds) {
        var r = scriptAds[i].parentNode;
        if (r == body) {
            scriptAds[i].remove();
        } else {
            r.remove();
        }
        c2++;
    }

    // 两边悬浮广告
    var c3 = 0;
    var floatAds = element(d, 'div', 'id', /cproIframe\dholder/);
    for (i in floatAds) {
        floatAds[i].remove();
        c3++;
    }
    if (c1 + c2 + c3 > 0) liberator.echo('移除内容中广告' + c1 + '个，移除边栏广告' + c2 + '个，悬浮广告' + c3 + '个');
});
/* vim:se sts=4 sw=4 et: */
