#!/usr/bin/awk -f

/#/ { print; next; }
/location \// { root = 1 }
/}/ \
{
	print;
	if (!root) next;
	print "\
	location ~ ^\/captcha\/ {\
		proxy_pass         http://127.0.0.1:8080;\
		proxy_cache off;\
		proxy_set_header   Host             $host;\
		proxy_set_header   X-Real-IP        $remote_addr;\
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;\
	}";
	root = "";
	printed = 1;
}
/\^\[\^captcha.+\(/ \
{
#	sub("\^\[\^captcha\/\]\.\+\\\.", "location ~* ");
	sub(/\^\[\^captcha\/\]\.\+\\?\./, "");
}
{
	if (!printed) print;
	printed = "";
}
