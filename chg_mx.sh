sed -i .bak -E 's/(100( |	))mail.ppcd.ru/\1mx.lenera.ru/p;s/(100( |	))mx.lenera.ru/110\2mail.ppcd.ru/' /etc/namedb/master/*
sed -i .bak2 -E 's/(.*)[0-9]{10}/\12008082705/' `find /etc/namedb/master/ -not -name "*.bak" -exec grep -l mx.lenera {} \;`
