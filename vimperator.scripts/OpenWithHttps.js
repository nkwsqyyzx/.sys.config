commands.addUserCommand ("OpenWithHttps", "open url with https",
    function (args) {
        var url = buffer.URL; 
        if (url.lastIndexOf("https:",0) < 0)
        {
            var httpsUrl = url.replace(/^http:/,"https:");
            liberator.open(httpsUrl);
        }
        else
        {
            liberator.echo("Current is https,perhaps you would try proxy.");
        }
    }
);

/* vim:se sts=4 sw=4 et: */
