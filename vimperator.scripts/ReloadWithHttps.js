commands.addUserCommand ("ReloadWithHttps", "reload url with https", function (args) {
    let d = tabs.getTab(args-1).linkedBrowser.contentDocument;
    let target = d.getElementById('errorTitleText');
    if (target){
        let url = buffer.URL;
        let google = /^http:\/\/www\.google\.com.+\/$/.test(url);
        let result = /^http:\/\/www\.google\.com.+url\?.+url=/.test(url);
        let search = /^http:\/\/www\.google\.com.+search\?.+&q=/.test(url);
        if (google || result || search) {
            let httpsUrl = url.replace(/^http:/,"https:");
            liberator.open(httpsUrl);
        }
    }
});
/* vim:se sts=4 sw=4 et: */
