let matches = [
    "阿甲秋",
    "澳洲甲",
    "巴甲",
    "比甲",
    "德甲",
    "德乙",
    "俄超",
    "俄甲",
    "法甲",
    "法乙",
    "哥伦甲秋",
    "荷甲",
    "欧冠杯",
    "欧罗巴杯",
    "葡超",
    "日职联",
    "日职乙",
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
    "英足总杯",
    "友谊赛",
    "中超",
    "自由杯"
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
