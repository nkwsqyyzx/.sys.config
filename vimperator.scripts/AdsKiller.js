function element(d,tag,property,pattern){
    var a = d.getElementsByTagName(tag);
    var rs = [];
    for (var attr,i = 0,l = a.length;i<l;i++) {
        attr = a[i].getAttribute(property);
        if (attr === undefined)
            continue;
        if (pattern.test(attr))
            rs.push(a[i]);
    }
    return rs;
}

commands.addUserCommand ("AdsKill", "kill adds", function (args) {
    let d = tabs.getTab(args-1).linkedBrowser.contentDocument;

    // 内容中的广告
    var divs = element(d,'div','class',/entry-?content/);
    for (i in divs){
        var div = divs[i];
        var suspect = element(div,'script','src',/adsbygoogle/);
        for (j in suspect) {
            var ad = suspect[j].parentNode;
            ad.remove();
        }
    }

    // 侧边栏的广告
    var lis = element(d,'li','class',/^/);
    for (i in lis){
        var suspect = element(lis[i],'script','src',/adsbygoogle/);
        for (j in suspect) {
            suspect[j].parentNode.remove();
        }
    }
});
/* vim:se sts=4 sw=4 et: */
