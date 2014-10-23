commands.addUserCommand("RemoveGoogleOnMouseDown", "Remove google search result onmousedown event handler", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    $('a[target=_blank]',d).filter(function(){
        var link = $(this).attr('href');
        return link && !link.contains('http://www.google.com');
    }).each(function(){
        $(this).removeAttr('onmousedown');
    });
});

autocommands.add('PageLoad', /www\.google\.com/, 'RemoveGoogleOnMouseDown <tab>');
/* vim:se sts=4 sw=4 et: */
