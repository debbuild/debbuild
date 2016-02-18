%define name    gtkmm
%define version 1.2.4
%define rel     1
# api is the part of the library name before the .so
%define api 1.2
# major is the part of the library name after the .so
%define major 1
%define libname %mklibname %{name} %{api} %{major}
%define develname %mklibname %{name} -d

# Original library name is libfoo
%global shortname foo
%global libname2 %mklibname %{shortname} 1 2
%global devname %mklibname -d %{shortname}

Name:           %{name}

#(!) summary for SRPM only
Summary:        C++ interface for popular GUI library gtk+
Version:        %{version}
Release:        %mkrel %{rel} -c rc1
License:        GPL2

%description
#Full and generic description of the whole package. (this will be the SRPM
#description only)

#main package (contains .so.[major]. only)
%package -n     %{libname}

#(!) summary for main lib RPM only
Summary:        Main library for gtkmm 
Group:          System/Libraries
Provides:       %{name} = %{version}-%{release}

%description -n %{libname}
This package contains the library needed to run programs dynamically
linked with gtkmm.

%package -n     %{develname}
Summary:        Headers for developing programs that will use Gtk--
Group:          Development/GNOME and GTK+
Requires:       %{libname} = %{version}
#(!) MANDATORY
Provides:       %{name}-devel = %{version}-%{release}

%description -n %{develname}
This package contains the headers that programmers will need to develop
applications which will use Gtk--, the C++ interface to the GTK+ (the Gimp
ToolKit) GUI library.

%prep
%{echo:%libname}
%{echo:%libname2}
%{echo:%develname}
%{echo:%devname}
%{echo:'%release'}

%files -n %{libname}
# ..
# include the major number (and api if present) in the file list to catch
changes on version upgrade
%{_libdir}/lib-%{api}.so.%{major}*

%files -n %{develname}
# ..
%{multiarch_bindir}/gtkmm-config
%{_bindir}/gtkmm-config
%{_includedir}/*.h
%{_libdir}/*.so
