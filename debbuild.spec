# $Id: debbuild.spec 201 2015-08-03 21:36:21Z kdeugau $
# Refer to the following for more info on .spec file syntax:
#   http://www.rpm.org/max-rpm/
#   http://www.rpm.org/max-rpm-snapshot/	(Updated version of above)
#   http://docs.fedoraproject.org/drafts/rpm-guide-en/
# More links may be available from http://www.rpm.org

Summary: Build Debian-compatible .deb packages from RPM .spec files
Name: debbuild
Version: 0.15.11a
Release: ascherer.%{dist}

Source: https://github.com/ascherer/debbuild/archive/%{name}-%{version}.tar.gz
URL: https://github.com/ascherer/debbuild
%if %{_vendor} == "debbuild"
# Use Debian sections here
Group: devel
%else
Group: Development/Tools
%endif
License: GPLv2+
Packager: Andreas Scherer <andreas@komputer.de>

Requires: perl, build-essential, fakeroot, bash
%if %{_vendor} == "debbuild"
Recommends: patch, bzip2, xz-utils, pax
Suggests: rpm, subversion
%endif
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

%define darch %{_bindir}/dpkg-architecture

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
# nothing to do here

%install
# Steps to install to a temporary location for packaging
%make_install
%{__mkdir_p} %{buildroot}%{_prefix}/lib/%{name}
%{__cp} glomacros %{buildroot}%{_prefix}/lib/%{name}/macros
%{__mkdir_p} %{buildroot}%{_sysconfdir}/%{name}
%{__cp} macros.sysutils %{buildroot}%{_sysconfdir}/%{name}
%{__cp} macros.texlive %{buildroot}%{_sysconfdir}/%{name}

# Fill in the pathnames to be packaged here
%files
%{_bindir}/*
%{_mandir}/man8/*
%{_prefix}/lib/%{name}/macros
%{_sysconfdir}/%{name}/macros.sysutils
%{_sysconfdir}/%{name}/macros.texlive

%post
if [ -x %{darch} ]; then
DEB_HOST_CPU=`%{darch} -qDEB_HOST_GNU_CPU 2>/dev/null`
DEB_HOST_OS=`%{darch} -qDEB_HOST_ARCH_OS 2>/dev/null`
DEB_HOST_SYSTEM=`%{darch} -qDEB_HOST_GNU_SYSTEM 2>/dev/null`
DEB_HOST_ARCH=`%{darch} -qDEB_HOST_ARCH_CPU 2>/dev/null`
DEB_BUILD_ARCH=`%{darch} -qDEB_BUILD_ARCH 2>/dev/null`

%{__sed} -e "s/@HOST_ARCH@/${DEB_HOST_ARCH}/g" \
         -e "s/@BUILD_ARCH@/${DEB_BUILD_ARCH}/g" \
         -e "s/@BUILD_OS@/${DEB_BUILD_OS}/g" \
         -e "s/@HOST_CPU@/${DEB_HOST_CPU}/g" \
         -e "s/@HOST_OS@/${DEB_HOST_OS}/g" \
         -e "s/@HOST_SYSTEM@/${DEB_HOST_SYSTEM}/g" \
         -i %{_prefix}/lib/%{name}/macros
fi

%changelog
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
