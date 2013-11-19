commands.addUserCommand ("ReloadWithHttps", "reload url with https", function (args) {
    let d = tabs.getTab(args-1).linkedBrowser.contentDocument;
    let target = d.getElementById('errorTitleText');
    if (target){
        let url = buffer.URL;
        let b = /^http:\/\/www\.google\.com.+url\?.+url=/.test(url);
        if (b) {
            let httpsUrl = url.replace(/^http:/,"https:");
            liberator.open(httpsUrl);
            return;
        }
    }
});
/* vim:se sts=4 sw=4 et: */
