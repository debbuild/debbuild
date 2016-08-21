# $Id: debbuild.spec 162 2012-04-09 01:18:25Z kdeugau $
# Refer to the following for more info on .spec file syntax:
#   http://www.rpm.org/max-rpm/
#   http://www.rpm.org/max-rpm-snapshot/	(Updated version of above)
#   http://docs.fedoraproject.org/drafts/rpm-guide-en/
# More links may be available from http://www.rpm.org

# A collection of magic to set the release "number" such that dist upgrades will, erm, upgrade.
# NB:  This really only applies to packages built with debbuild.
%if %{?debdist:0}%{?!debdist:1}
%define debdist etch
%endif
%if "%{debdist}" == "sarge"
%define errata 0
%endif
%if "%{debdist}" == "dapper"
%define errata 1
%endif
%if "%{debdist}" == "etch"
%define errata 2
%endif
%if "%{debdist}" == "lenny"
%define errata 3
%endif
if "%{debdist}" == "squeeze"
%define errata 4
%endif
if "%{debdist}" == "wheezy"
%define errata 5
%endif
%if %{?relnum:0}%{?!relnum:1}
%define relnum 1
%endif

# %{_vendor} is only set to "redhat" on Red Hat (Enterprise) Linux and direct
# derivatives/ancestors (eg Fedora Core).  Upstream rpm (as packaged in Debian,
# for instance) sets it to "rpm".  debbuild sets it to "debbuild".
%if %{_vendor} == "redhat"
%define errata el4
%define release %{relnum}.%{errata}
%else
%define release %{relnum}.%{errata}%{debdist}
%endif

Summary: Build Debian-compatible .deb packages from RPM .spec files
Name: debbuild
Version: 0.9.5
Release: %{release}
Source: http://www.deepnet.cx/debbuild/debbuild-%{version}.tar.gz
Group: Development/Tools
License: GPLv2
Packager: Kris Deugau <kdeugau@deepnet.cx>
Requires: perl, build-essential, pax, fakeroot
%if %{_vendor} == "debbuild"
Recommends: patch, bzip2
Suggests: rpm, subversion
%endif
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

%description
debbuild attempts to build Debian-friendly semi-native packages from
RPM spec files, RPM-friendly tarballs, and RPM source packages
(.src.rpm files).  It accepts most of the options rpmbuild does, and
should be able to interpret most spec files usefully.  Perl modules
should be handled via CPAN+dh-make-perl instead as it's simpler
than even tweaking a .spec template.

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
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

# Fill in the pathnames to be packaged here
%files
%{_bindir}/*
%{_mandir}/man8/*

%changelog
* Thu Feb 28 2008  Kris Deugau <kdeugau@deepnet.cx> -1
- Initial package
