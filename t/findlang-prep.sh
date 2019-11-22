#!/bin/sh

rm -fr /tmp/find-lang-root
touch /tmp/langfile

for file in \
    /tmp/find-lang-root/usr/share/man/fr/man1/lang.1.lzma \
    /tmp/find-lang-root/usr/share/locale/pt_BR/LC_MESSAGES/lang.mo \
    /tmp/find-lang-root/usr/share/gnome/help/lang/pt_BR/any.html \
    /tmp/find-lang-root/usr/share/gnome/help/lang/en_GB/any.html
do install -D /tmp/langfile $file
done
