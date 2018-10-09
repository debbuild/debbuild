# quick makefile for debbuild
# $Id: Makefile 200 2015-08-03 21:34:33Z kdeugau $

MANIFEST = \
	debbuild Makefile COPYING debbuild.spec

PKGNAME=debbuild
VERSION=@VERSION@

BINDIR=/usr/bin
LIBDIR=/usr/lib
MANDIR=/usr/share/man
CONFDIR=/etc

all:
	# nothing to do

install:
	mkdir -p $(DESTDIR)$(BINDIR)
	cp debbuild $(DESTDIR)$(BINDIR)

	mkdir -p $(DESTDIR)$(LIBDIR)/$(PKGNAME)/macros.d
	cp macros/macros.in $(DESTDIR)$(LIBDIR)/$(PKGNAME)/macros
	cp macros/macros.perl $(DESTDIR)$(LIBDIR)/$(PKGNAME)/macros.d
	cp config/debrc $(DESTDIR)$(LIBDIR)/$(PKGNAME)

	mkdir -p $(DESTDIR)$(CONFDIR)/$(PKGNAME)
	cp macros/macros.sysutils $(DESTDIR)$(CONFDIR)/$(PKGNAME)
	cp macros/macros.texlive $(DESTDIR)$(CONFDIR)/$(PKGNAME)

	mkdir -p $(DESTDIR)$(MANDIR)/man8
	pod2man --utf8 --center="DeepNet Dev Tools" --section 8 \
		debbuild > $(DESTDIR)$(MANDIR)/man8/debbuild.8

dist:
	mkdir $(PKGNAME)-$(VERSION)
	tar cf - $(MANIFEST) | (cd $(PKGNAME)-$(VERSION); tar xvf -)
	#/usr/bin/perl -p -e 's/#VERSION#/$(VERSION)/' < $(PKGNAME).spec > $(PKGNAME)-$(VERSION)/$(PKGNAME).spec
	#/usr/bin/perl -p -e 's/[\d.]+";	#VERSION#/$(VERSION)";/' < debbuild > $(PKGNAME)-$(VERSION)/debbuild
	tar cvf $(PKGNAME)-$(VERSION).tar $(PKGNAME)-$(VERSION)
	gzip -v -f -9 $(PKGNAME)-$(VERSION).tar
	rm -rf $(PKGNAME)-$(VERSION)
	gpg -a --detach-sign $(PKGNAME)-$(VERSION).tar.gz
