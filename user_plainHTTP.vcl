backend default {
    .host = "127.0.0.1";
    .port = "8080";

}
sub vcl_recv {
unset req.http.Accept-Encoding;
 ## what files to cache (lookup) - just add if needed
  if (req.url ~ "(?i)\.(jpeg|jpg|png|gif|ico|webp|js|css|txt|pdf|gz|zip|lzma|bz2|tgz|tbz|html|htm)$" || req.url ~ "^/hh/img/") {
      return(lookup);
  }
}
sub vcl_fetch {
  # what files to handle (the cached ones)  - just add if needed

      if (req.url ~ "(?i)\.(jpeg|jpg|png|gif|ico|webp|js|css|txt|pdf|gz|zip|lzma|bz2|tgz|tbz|html|htm)$" || req.url ~ "^/hh/img/") {
        unset beresp.http.Set-Cookie;
        set beresp.ttl = 1h;
  }
}

sub vcl_deliver {
 # if a varnish object hits, send X-cache header with HIT

    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";

 # otherwise, send X-cache header with MISS
    } else {
        set resp.http.X-Cache = "MISS";
    }
}

sub vcl_error {
}

sub vcl_hash {
}
