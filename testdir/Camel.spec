Name:            hello
Version:         2.10
Release:         4%{?dist}
Summary:         A Hello World application from the GNU Project

License:         GPLv3+
URL:             https://www.gnu.org/software/hello/
Source0:         http://ftp.gnu.org/gnu/hello/%{name}-%{version}.tar.gz

%if %{_vendor} == "debbuild"
Packager:        Neal Gompa <ngompa13@gmail.com>
%endif

Requires(post):  info
Requires(preun): info

%define _Main_path /opt/Program
%define _main_path /opt/program

%description
The GNU Hello program is a Free Software take on
the classical Hello World application. It uses autotools
and offers extensive language support. It is often used
as an example of how Free Software can be written and
packaged.

%prep
echo %{_Main_path}
echo %{_main_path}
