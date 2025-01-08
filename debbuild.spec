# Refer to the following for more info on .spec file syntax:
#
#   http://www.rpm.org/max-rpm/
#   http://www.rpm.org/max-rpm-snapshot/	(Updated version of above)
#   https://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/
#   https://rpm-packaging-guide.github.io/
#
# More links may be available from http://www.rpm.org

%global debconfigdir %{_prefix}/lib/debbuild

Name:           debbuild
Summary:        Build Debian-compatible .deb packages from RPM .spec files
Version:        24.12.0
Release:        0%{?dist}
%if 0%{?_debbuild:1}
Packager:       debbuild developers <https://github.com/debbuild/debbuild>
Group:          devel
%else
Group:          Development/Tools%{?suse_version:/Building}
%endif
License:        GPL-2.0-or-later
URL:            https://github.com/debbuild/debbuild
Source:         %{url}/archive/%{version}/%{name}-%{version}.tar.gz
BuildArch:      noarch

%if 0%{?_debbuild:1}
BuildRequires:  podlators-perl
BuildRequires:  lsb-release
Requires:       liblocale-gettext-perl
Requires:       lsb-release
Requires:       xz-utils
Recommends:     dpkg-sig
Suggests:       rpm
Suggests:       ruby
%else
BuildRequires:  perl-generators
BuildRequires:  perl(Pod::Man)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
Requires:       xz
Suggests:       rubygems
%endif

BuildRequires:  gettext

Requires:       bash
Requires:       bzip2
Requires:       dpkg
Requires:       dpkg-dev
Requires:       fakeroot
Requires:       gzip
Requires:       patch
Requires:       pax
Requires:       perl

Recommends:     git-core
Recommends:     quilt
Recommends:     unzip
Recommends:     zip
Recommends:     zstd

Recommends:     %{name}-lua-support

%description
debbuild attempts to build Debian-friendly semi-native packages from
RPM spec files, RPM-friendly tarballs, and RPM source packages
(.src.rpm files).  It accepts most of the options rpmbuild does, and
should be able to interpret most spec files usefully.

%package lua-support
Summary:        Lua macro support for debbuild
Requires:       %{name} = %{version}-%{release}
%if 0%{?_debbuild:1}
Requires:       liblua-api-perl
%else
Requires:       perl(Lua::API)
%endif

%description lua-support
This package adds the dependencies to support RPM macros
written the Lua programming language.

%prep
# Steps to unpack and patch source as needed
%autosetup

%build
%configure --debconfigdir=%{debconfigdir} VERSION=%{version}
make

%install
%make_install

# Identify all installed translations
%find_lang %{name}

%files -f %{name}.lang
# Fill in the pathnames to be packaged here
%doc README.md
%license COPYING
%{_bindir}/*
%{_mandir}/man8/*
%{debconfigdir}/
%{_sysconfdir}/debbuild/

%files lua-support
# Empty metapackage

%changelog
* Sat Feb 19 2022 Neal Gompa <ngompa13@gmail.com>
- Add subpackage for pulling in support for RPM macros written in Lua

* Mon Dec 28 2020 Neal Gompa <ngompa13@gmail.com>
- Quote words on both sides of string comparisons for RPM 4.16+ compatibility

* Fri Mar 06 2020 Neal Gompa <ngompa13@gmail.com>
- Use the find_lang macro to install translations

* Fri Nov 22 2019 Neal Gompa <ngompa13@gmail.com>
- Modernize and clean up the spec file

* Fri Feb 01 2019  Andreas Scherer <https://ascherer.github.io/>
- Replace debsigs with dpkg-sig for package signing

* Sun Nov 11 2018  Andreas Scherer <https://ascherer.github.io/>
- Install German language pack

* Sun Feb 19 2017  Andreas Scherer <https://ascherer.github.io/>
- Set up infrastructure for signing packages

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
