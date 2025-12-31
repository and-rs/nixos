from mitmproxy import http, ctx
from functools import lru_cache
import urllib.request
import json


@lru_cache(maxsize=1000)
def is_nsfw(subreddit: str) -> bool:
    try:
        url = f"https://api.reddit.com/r/{subreddit}/about.json"
        req = urllib.request.Request(
            url, headers={"User-Agent": "mitmproxy-reddit-blocker"}
        )
        with urllib.request.urlopen(req, timeout=5) as r:
            data = json.loads(r.read().decode())
            result = data.get("data", {}).get("over_18", False)
            ctx.log.info(f"{subreddit}: {result}")
            return result
    except Exception as e:
        ctx.log.error(f"Error checking {subreddit}: {e}")
        return False


class BlockNSFWSubreddits:
    def request(self, flow: http.HTTPFlow) -> None:
        if "reddit.com" in flow.request.host and "/r/" in flow.request.path:
            sub = flow.request.path.split("/r/")[1].split("/")[0]
            if sub and is_nsfw(sub):
                flow.response = http.Response.make(403, b"NSFW blocked")


addons = [BlockNSFWSubreddits()]
