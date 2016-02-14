Name:           debbuild
Version:        15.12.0
Release:        1%{?dist}
Summary:        Build Debian-compatible .deb packages from RPM .spec files

License:        GPLv2+
URL:            https://secure.deepnet.cx/trac/debbuild
Source0:        https://github.com/ascherer/debbuild/archive/%{name}-%{version}.tar.gz

%if %{_vendor} == "debbuild"
Packager:        Neal Gompa <ngompa13@gmail.com>
%endif

BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root

%if %{_vendor} == "debbuild"
BuildRequires:  podlators-perl
Requires:       xz-utils
%else
#BuildRequires:  perl(Pod::Man)
Requires:       xz
%endif

Requires:       perl
Requires:       dpkg, dpkg-dev
Requires:       pax, bzip2 
Requires:       fakeroot, bash, patch, rpm

%description
debbuild attempts to build Debian-friendly semi-native packages from
RPM spec files, RPM-friendly tarballs, and RPM source packages
(.src.rpm files).  It accepts most of the options rpmbuild does, and
should be able to interpret most spec files usefully.

%package -n debscript
Summary: debscript summary
%description -n debscript
bla

%changelog -n debscript
* Tue Dec 01 2015 Andreas Scherer <andreas@komputer.de> - 0.15.11-1
- Update to 0.15.11 release with subpackage debscript

* Fri Jul 17 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.11.2-1
- Update to 0.11.2 release

%if %{_vendor} == "debbuild"

%copyrightdata -n debscript
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: debbuild
Upstream-Contact: Kris Deugau <kdeugau@deepnet.cx>
Source: https://secure.deepnet.cx/trac/debbuild

Files: *
Copyright: © 2005-2015 Kris Deugau
License: GPL-2+

This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public
License along with this package; if not, write to the Free
Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301 USA

On Debian systems, the full text of the GNU General Public
License version 2 can be found in the file
`/usr/share/common-licenses/GPL-2'.

%endif

%prep
%setup -q


%build


%install
%{__rm} -rf %{buildroot}
%make_install


%files -n debscript
%defattr(-,root,root,-)
%{_bindir}/debbuild
%{_mandir}/man8/*.8*

%if %{_vendor} == "redhat"
%license COPYING
%else
%doc COPYING
%endif


%changelog
* Mon Nov 23 2015 Andreas Scherer <andreas@komputer.de> - 0.15.11-1
- Update to 0.15.11 release

* Mon Sep  7 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.11.3-1
- Update to 0.11.3 release

* Fri Jul 17 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.11.2-1
- Update to 0.11.2 release

* Sun Jun  7 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.10.1-1
- Update to 0.10.1 release

* Thu May 28 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.10.0-1
- Update to 0.10.0 release

* Wed May 13 2015 Neal Gompa <ngompa13{%}gmail{*}com> - 0.9.9-1.20150508svn179
- Initial packaging
