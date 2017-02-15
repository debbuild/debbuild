# $Id: debbuild.spec 201 2015-08-03 21:36:21Z kdeugau $
# Refer to the following for more info on .spec file syntax:
#   http://www.rpm.org/max-rpm/
#   http://www.rpm.org/max-rpm-snapshot/	(Updated version of above)
#   http://docs.fedoraproject.org/drafts/rpm-guide-en/
# More links may be available from http://www.rpm.org

Name: debbuild
Summary: Build Debian-compatible .deb packages from RPM .spec files
Version: 17.2.2
Release: ascherer.%{dist}

Source: https://github.com/ascherer/debbuild/archive/%{name}-%{version}.tar.gz
URL: https://github.com/ascherer/debbuild
%if %{_vendor} == "debbuild"
Group: devel
%else
Group: Development/Tools/Building
%global dist ubuntu16.04
%endif
License: GPLv2+
Packager: Andreas Scherer <https://ascherer.github.io/>

Requires: dpkg-dev, perl, fakeroot
%if %{_vendor} == "debbuild"
Requires: lsb-release
Recommends: bzip2, gzip, xz-utils, unzip, zip
Recommends: git, patch, pax, quilt
Suggests: rpm, subversion
%endif
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

%description
debbuild attempts to build Debian-friendly semi-native packages from
RPM spec files, RPM-friendly tarballs, and RPM source packages
(.src.rpm files).  It accepts most of the options rpmbuild does, and
should be able to interpret most spec files usefully.

Note that patch is not strictly required unless you have .spec files
with %patch directives, and RPM is not required unless you wish to
rebuild .src.rpm source packages as .deb binary packages.

%prep
# Steps to unpack and patch source as needed
%setup -q

%build
# Transfer $VERSION into the live system
for i in debbuild Makefile; do %{__sed} "s/\@VERSION\@/%{version}/" -i $i; done

%install
# Steps to install to a temporary location for packaging
%make_install
%{__mkdir_p} %{buildroot}%{_libdir}/%{name}/macros.d
%{__cp} macros/macros.in %{buildroot}%{_libdir}/%{name}/macros
%{__cp} macros/macros.perl %{buildroot}%{_libdir}/%{name}/macros.d
%{__mkdir_p} %{buildroot}%{_sysconfdir}/%{name}
%{__cp} macros/macros.sysutils %{buildroot}%{_sysconfdir}/%{name}
%{__cp} macros/macros.texlive %{buildroot}%{_sysconfdir}/%{name}

%files
# Fill in the pathnames to be packaged here
%{_bindir}/*
%{_mandir}/man8/*
%{_libdir}/%{name}/macros
%{_libdir}/%{name}/macros.d/*
%{_sysconfdir}/%{name}/macros.*


%changelog
* Sat Dec  3 2016  Neal Gompa <ngompa13@gmail.com>
- Integrate platform detection into macros
- Remove unnecessary scriptlet

* Fri Oct 28 2016  Neal Gompa <ngompa13@gmail.com>
- Add lsb-release as requirement

* Sat Dec 12 2015  Andreas Scherer <https://ascherer.github.io/>
- Centrally control and distribute the 'version' number

* Fri Dec  4 2015  Neal Gompa <ngompa13@gmail.com>
- Update spec and host/build auto-configure

* Tue Nov 17 2015  Andreas Scherer <andreas_tex@freenet.de>
- Auto-configure host/build environment

* Sat Nov 14 2015  Andreas Scherer <andreas_tex@freenet.de>
- Add debbuild's own set of macros

* Sun Jul 19 2015  Kris Deugau <kdeugau@deepnet.cx>
- Remove the stack of %if's determining the Debian dist;  use the recently
  refined %{dist} instead

* Thu Feb 28 2008  Kris Deugau <kdeugau@deepnet.cx> -1
- Initial package
