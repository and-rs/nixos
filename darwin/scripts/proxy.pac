function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, "reddit.com") ||
        dnsDomainIs(host, "www.reddit.com") ||
        dnsDomainIs(host, "old.reddit.com") ||
        dnsDomainIs(host, "i.redd.it") ||
        dnsDomainIs(host, "v.redd.it") ||
        dnsDomainIs(host, "alb.reddit.com") ||
        host === "reddit.com") {
        return "PROXY 127.0.0.1:8080";
    }
    return "DIRECT";
}
