#!/bin/sh

rm -fr find-lang-root
for file in \
    find-lang-root/usr/share/man/fr/man1/lang.1.lzma \
    find-lang-root/usr/share/locale/pt_BR/LC_MESSAGES/lang.mo \
    find-lang-root/usr/share/gnome/help/lang/pt_BR/any.html \
    find-lang-root/usr/share/gnome/help/lang/en_GB/any.html
do install -D find-lang.pl $file
done

exec perl tests/findlang.pl
