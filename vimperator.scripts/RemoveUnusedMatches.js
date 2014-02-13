let matches = [
    "阿甲秋",
    "澳洲甲",
    "巴甲",
    "比甲",
    "德甲",
    "德乙",
    "法甲",
    "法乙",
    "非冠杯",
    "非联杯",
    "芬联杯",
    "哥伦甲秋",
    "荷甲",
    "葡超",
    "瑞士超",
    "瑞士甲",
    "苏超",
    "土超",
    "西甲",
    "西乙",
    "希腊超",
    "亚冠杯",
    "意甲",
    "意乙",
    "英超",
    "英冠",
    "英甲",
    "英足总杯"
];

commands.addUserCommand("RemoveUnusedMatches", "删除无用的比赛", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    //let d = aWindow.document;
    var table_live = $('[id="table_live"]',d);

    $('tr',table_live).filter(function(){
        var font = $('font[color="white"]',$(this));
        if (font){
            var m = font.text();
            var index = matches.indexOf(m);
            return index < 0;
        }
        return false;
    }).each(function(){
        $(this).remove();
    });
});

autocommands.add('DOMLoad', /.+\.bet007\.com\/Next.+/, 'RemoveUnusedMatches <tab>');
autocommands.add('PageLoad', /.+\.bet007\.com\/Next.+/, 'RemoveUnusedMatches <tab>');
/* vim:se sts=4 sw=4 et: */
