%bcond_with      fulldoc
%bcond_without   patches

%include %{_specdir}/whatever.spec

#%unknown

%define major 1
%define libname %{mklibname %{name} %{api} %{major}}
%define develname %mklibname %{name} -d
 
%define _initddir /hello/world

%{?!_unitdir:%global _unitdir /lib/systemd/system}
%{?!_initddir:%global _initddir /etc/init.d}
%{?!_jobsdir:%global _jobsdir /etc/init}

Name:            hello
Version:         2.10
Release:         4%{?dist}
Summary:         A Hello World application from the GNU Project

License:         GPLv3+
URL:             https://www.gnu.org/software/hello/
Source0:         http://ftp.gnu.org/gnu/hello/%{name}-%{version}.tar.gz
Source1:         http://ftp.gnu.org/gnu/hello/%{name}-%{version}-II.tar.gz

%if %{_vendor} == "debbuild"
%{perl:for my $val (1..12) { printf("Patch%d: bash42\_%04d\n",$val,$val) }}
%endif

%if %{_vendor} == "debbuild"
Packager:        Neal Gompa <ngompa13@gmail.com>
%endif

#uildRequires:   gettext

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
echo %{F:scripts/post.sh}
echo %{S:0}
echo %{P:7}

%{?_rpmconfigdir:%include %{_rpmconfigdir}/macros.perl}
echo %perl_sitearch
echo %perl_sitelib
echo %perl_vendorarch
echo %perl_vendorlib
echo %perl_archlib
echo %perl_privlib

%{echo:%_unitdir}
%{echo:%_initddir}
%{echo:%_jobsdir}

#%include %{_rpmconfigdir}/macros.python
#echo %python_version
#echo %py_ver
#echo %py_prefix
#echo %py_libdir
#echo %py_incdir
#echo %py_sitedir
#echo %py_dyndir
#echo %python_sitelib
#echo %python_sitearch

%if %{with patches}
%{echo:Hello 1}
%endif
%if ! %{with patches}
%{echo:Hello 2}
%endif
%if %{without patches}
%{echo:Hello 2}
%endif

echo PREP
%{echo:%{url2path:https://www.server.com:6666/their/local/path%{_datadir}/%{basename:%{S:0}}}}
%{echo:%{basename:%{S:0}},%{basename:%{S:1}}}
%{echo:%{dirname:%{S:0}}}
%{echo:%{suffix:%{S:0}}}

#dump

%{echo:%{?_with_fulldoc}}
%{echo:%{?_without_patches}}

%define functional()	%{expand:%%{?%{1}:1}%%{!?%{1}:0}}

%define ubuntu 1504
%define debian 8
%define rhel 7
%undefine suse_version
%undefine fedora # 15

%{echo:%{?ubuntu}}
%{echo:%{?debian}}

%if %{?ubuntu:%{?ubuntu}<1504}%{!?ubuntu:0} || %{?debian:%{?debian}<8}%{!?debian:0} || %{?rhel:%{?rhel}<7}%{!?rhel:0} || %{?suse_version:%{?suse_version}<1230}%{!?suse_version:0} || %{?fedora:%{?fedora}<15}%{!?fedora:0}
#%if 0%{?ubuntu} >= 1504 || 0%{?debian} >= 8 || 0%{?rhel} >= 7 || 0%{?suse_version} >= 1230 || 0%{?fedora} >= 15
%{echo:systemd}
%else
%{echo:sysv}
%endif

%if 1
%setup -q
%endif

%if %{_vendor} == "debbuild"
%{echo:%mklibsymbols test 42}
%{echo:%mklibname test 1 -d 0 -s}
%{echo:%{mklibname test 1 -d 0 -s}-whatever}
%systemd_preun foo.service bar.service
%{echo:%{libname}}
  %if 1
    echo "Hello, indented."
  %endif
%endif

%build
%{echo:%{?_with_fulldoc}}
echo BUILD
%configure
# --enable-doc --disable-static
%{?make_build:%make_build}%{?!make_build:make %{?_smp_mflags}}

%check
echo CHECK

%install
%make_install
rm -f %{buildroot}%{_infodir}/dir

%if 0%{?ubuntu} < 15 || 0%{?debian} < 8 || 0%{?rhel} < 7 || 0%{?suse_version} < 1230 || 0%{?fedora} < 15
mkdir -p %{buildroot}%{_sysconfdir}/helloconf
touch %{buildroot}%{_sysconfdir}/helloconf/sysv
%else
mkdir -p %{buildroot}%{_sysconfdir}/helloconf
touch %{buildroot}%{_sysconfdir}/helloconf/systemd
%endif

%post
/sbin/install-info %{_infodir}/%{name}.info %{_infodir}/dir || :

%preun
# Run only on final removal
if [ $1 = 0 ] ; then
/sbin/install-info --delete %{_infodir}/%{name}.info %{_infodir}/dir || :
fi

%files
%{_bindir}/%{name}
%{_infodir}/*
%{_mandir}/*
%{_datadir}/locale/*
%dir %{_sysconfdir}/helloconf
%{_sysconfdir}/helloconf/*
%doc README NEWS ChangeLog AUTHORS TODO THANKS
%if %{_vendor} == "redhat" || %{_vendor} == "mageia"
%license COPYING
%else
%doc COPYING
%endif

%{echo:%{?_with_fulldoc}}

%changelog
