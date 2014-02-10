commands.addUserCommand("DeleteBaiduProAds", "删除百度推广", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    // 右下角的百度推广
    $('[id^="cproIframe1holder"]',d).each(function(){
        var t = $(this);
        t.remove();
    });
});

autocommands.add('PageLoad', /.*/, 'DeleteBaiduProAds <tab>');
autocommands.add('DOMLoad', /.*/, 'DeleteBaiduProAds <tab>');
/* vim:se sts=4 sw=4 et: */
