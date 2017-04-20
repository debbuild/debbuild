# quick makefile for debbuild
# $Id: Makefile 200 2015-08-03 21:34:33Z kdeugau $

MANIFEST = \
	debbuild Makefile COPYING debbuild.spec

PKGNAME=debbuild
VERSION=@VERSION@

MANDIR=/usr/share/man
CONFDIR=/etc

all:
	# nothing to do

install:
	mkdir -p $(DESTDIR)/usr/bin
	cp debbuild $(DESTDIR)/usr/bin

	mkdir -p $(DESTDIR)$(MANDIR)/man8
	pod2man --utf8 --center="DeepNet Dev Tools" --section 8 \
		debbuild | gzip > $(DESTDIR)$(MANDIR)/man8/debbuild.8.gz

dist:
	mkdir $(PKGNAME)-$(VERSION)
	tar cf - $(MANIFEST) | (cd $(PKGNAME)-$(VERSION); tar xvf -)
	#/usr/bin/perl -p -e 's/#VERSION#/$(VERSION)/' < $(PKGNAME).spec > $(PKGNAME)-$(VERSION)/$(PKGNAME).spec
	#/usr/bin/perl -p -e 's/[\d.]+";	#VERSION#/$(VERSION)";/' < debbuild > $(PKGNAME)-$(VERSION)/debbuild
	tar cvf $(PKGNAME)-$(VERSION).tar $(PKGNAME)-$(VERSION)
	gzip -v -f -9 $(PKGNAME)-$(VERSION).tar
	rm -rf $(PKGNAME)-$(VERSION)
	gpg -a --detach-sign $(PKGNAME)-$(VERSION).tar.gz
