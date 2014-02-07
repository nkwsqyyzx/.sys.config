commands.addUserCommand("DeleteTitan007Ads", "delete titan007 ads", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    // 左右的广告
    var a = d.getElementsByTagName('div');
    for (i in a) {
        if (!a[i]) {
            continue;
        }
        var src = a[i].id;
        var b = /^lqdel|r$/.test(src);
        if (b) {
            a[i].remove();
        }
    }

    // 比分旁边的广告
    a = d.getElementsByTagName('span');
    for (i in a) {
        if (!a[i]) {
            continue;
        }
        var b = /^(left)|(right)_ad$/.test(a[i].id);
        if (b) {
            a[i].remove();
        }
    }

    // 比分之间的广告
    var a = d.getElementsByTagName('tr');
    for (i in a) {
        if (!a[i]) {
            continue;
        }
        var b = /^tr_ad\d*$/.test(a[i].id);
        if (b) {
            a[i].remove();
        }
    }
    $('[id^="Ad"]',d).each(function(){
        $(this).remove();
    });

    $('a[target=_blank]',d).filter(function(){
        var link = $(this).attr('href');
        return link && !link.contains('007');
    }).each(function(){
        $(this).remove();
    });
});

autocommands.add('DOMLoad', /live2\.titan007\.com/, 'DeleteTitan007Ads <tab>');
autocommands.add('PageLoad', /live2\.titan007\.com/, 'DeleteTitan007Ads <tab>');
autocommands.add('DOMLoad', /news\.bet007\.com/, 'DeleteTitan007Ads <tab>');
autocommands.add('PageLoad', /news\.bet007\.com/, 'DeleteTitan007Ads <tab>');
/* vim:se sts=4 sw=4 et: */
