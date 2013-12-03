commands.addUserCommand("ReloadWithHttps", "reload url with https", function (args) {
    let d = tabs.getTab(args - 1).linkedBrowser.contentDocument;
    let target = d.getElementById('errorTitleText');
    if (target) {
        let url = buffer.URL;
        let result = /\burl=/.test(url);
        let search = /\bsearch\?.{0,}q=/.test(url);
        if (result || search) {
            let httpsUrl = url.replace(/^http:/, "https:");
            liberator.open(httpsUrl);
        }
    }
});

autocommands.add('DOMLoad', /^http:\/\/www\.google\.com/, 'ReloadWithHttps <tab>');
/* vim:se sts=4 sw=4 et: */
