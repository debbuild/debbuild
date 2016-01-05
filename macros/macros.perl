#/*! \page config_macros Default configuration: /usr/lib/debbuild/macros.d/macros.perl
# \verbatim
#
# This is a global DEBBUILD configuration file. All changes made here will be
# lost when the debbuild package is upgraded. Any per-system configuration
# should be added to /etc/debbuild/macros, while per-user configuration should
# be added to ~/.debmacros.
#
#------------------------------------------------------------------------------
# Useful perl macros (from Artur Frysiak <wiget@t17.ds.pwr.wroc.pl>)
#
# For example, these can be used as (from ImageMagick.spec from PLD site)
#	[...]
#	BuildPrereq: perl
#	[...]
#	%package perl
#	Summary: libraries and modules for access to ImageMagick from perl
#	Group: Development/Languages/Perl
#	Requires: %{name} = %{version}
#	%requires_eq    perl
#	[...]
#	%install
#	rm -fr $RPM_BUILD_ROOT
#	install -d $RPM_BUILD_ROOT/%{perl_sitearch}
#	[...]
#	%files perl
#	%defattr(644,root,root,755)
#	%{perl_sitearch}/Image
#	%dir %{perl_sitearch}/auto/Image
#
%requires_eq()	%(LC_ALL="C" echo '%*' | xargs -r rpm -q --qf 'Requires: %%{name} = %%{epoch}:%%{version}\\n' | sed -e 's/ (none):/ /' -e 's/ 0:/ /' | grep -v "is not")
%perl_sitearch	%(eval "`%{__perl} -V:installsitearch`"; echo $installsitearch)
%perl_sitelib	%(eval "`%{__perl} -V:installsitelib`"; echo $installsitelib)
%perl_vendorarch %(eval "`%{__perl} -V:installvendorarch`"; echo $installvendorarch)
%perl_vendorlib  %(eval "`%{__perl} -V:installvendorlib`"; echo $installvendorlib)
%perl_archlib	%(eval "`%{__perl} -V:installarchlib`"; echo $installarchlib)
%perl_privlib	%(eval "`%{__perl} -V:installprivlib`"; echo $installprivlib)

# \endverbatim
#*/
