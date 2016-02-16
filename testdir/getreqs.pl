use Data::Dumper;

sub getreqs {
=pod
  my ($pkgtree) = @_;

  print "Checking library requirements...\n";
  my @binlist = qx ( $specglobals{__find} $pkgtree -type f -perm 755 );
  return () unless @binlist;

  my @reqlist = map { qx ( LANG=C $specglobals{__ldd} $_ ) } @binlist;
=cut
my @reqlist = ('linux-vdso.so.1 =>  (0x00007ffcbe368000)',
'libcurl.so.4 => /usr/lib/i386-linux-gnu/libcurl.so.4 (0x00007f4e29d41000)',
'libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0x00007f4e29b23000)',
'libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0x00007f4e29758000)',
'libidn.so.11 => /usr/lib/i386-linux-gnu/libidn.so.11 (0x00007f4e29525000)',
'librtmp.so.1 => /usr/lib/i386-linux-gnu/librtmp.so.1 (0x00007f4e29308000)',
'libssl.so.1.0.0 => /lib/i386-linux-gnu/libssl.so.1.0.0 (0x00007f4e2909e000)',
'libcrypto.so.1.0.0 => /lib/i386-linux-gnu/libcrypto.so.1.0.0 (0x00007f4e28c5c000)',
'libgssapi_krb5.so.2 => /usr/lib/i386-linux-gnu/libgssapi_krb5.so.2 (0x00007f4e28a12000)',
'liblber-2.4.so.2 => /usr/lib/i386-linux-gnu/liblber-2.4.so.2 (0x00007f4e28802000)',
'libldap_r-2.4.so.2 => /usr/lib/i386-linux-gnu/libldap_r-2.4.so.2 (0x00007f4e285b0000)',
'libz.so.1 => /lib/i386-linux-gnu/libz.so.1 (0x00007f4e28396000)',
'/lib64/ld-linux-i386-64.so.2 (0x00005627dd647000)',
'libgnutls-deb0.so.28 => /usr/lib/i386-linux-gnu/libgnutls-deb0.so.28 (0x00007f4e28079000)',
'libhogweed.so.4 => /usr/lib/i386-linux-gnu/libhogweed.so.4 (0x00007f4e27e46000)',
'libnettle.so.6 => /usr/lib/i386-linux-gnu/libnettle.so.6 (0x00007f4e27c10000)',
'libgmp.so.10 => /usr/lib/i386-linux-gnu/libgmp.so.10 (0x00007f4e2798f000)',
'libdl.so.2 => /lib/i386-linux-gnu/libdl.so.2 (0x00007f4e2778b000)',
'libkrb5.so.3 => /usr/lib/i386-linux-gnu/libkrb5.so.3 (0x00007f4e274b9000)',
'libk5crypto.so.3 => /usr/lib/i386-linux-gnu/libk5crypto.so.3 (0x00007f4e27289000)',
'libcom_err.so.2 => /lib/i386-linux-gnu/libcom_err.so.2 (0x00007f4e27085000)',
'libkrb5support.so.0 => /usr/lib/i386-linux-gnu/libkrb5support.so.0 (0x00007f4e26e7a000)',
'libresolv.so.2 => /lib/i386-linux-gnu/libresolv.so.2 (0x00007f4e26c5d000)',
'libsasl2.so.2 => /usr/lib/i386-linux-gnu/libsasl2.so.2 (0x00007f4e26a42000)',
'libgssapi.so.3 => /usr/lib/i386-linux-gnu/libgssapi.so.3 (0x00007f4e26802000)',
'libp11-kit.so.0 => /usr/lib/i386-linux-gnu/libp11-kit.so.0 (0x00007f4e2659c000)',
'libtasn1.so.6 => /usr/lib/i386-linux-gnu/libtasn1.so.6 (0x00007f4e26389000)',
'libkeyutils.so.1 => /lib/i386-linux-gnu/libkeyutils.so.1 (0x00007f4e26184000)',
'libheimntlm.so.0 => /usr/lib/i386-linux-gnu/libheimntlm.so.0 (0x00007f4e25f7b000)',
'libkrb5.so.26 => /usr/lib/i386-linux-gnu/libkrb5.so.26 (0x00007f4e25cf1000)',
'libasn1.so.8 => /usr/lib/i386-linux-gnu/libasn1.so.8 (0x00007f4e25a4d000)',
'libhcrypto.so.4 => /usr/lib/i386-linux-gnu/libhcrypto.so.4 (0x00007f4e2581a000)',
'libroken.so.18 => /usr/lib/i386-linux-gnu/libroken.so.18 (0x00007f4e25605000)',
'libffi.so.6 => /usr/lib/i386-linux-gnu/libffi.so.6 (0x00007f4e253fc000)',
'libwind.so.0 => /usr/lib/i386-linux-gnu/libwind.so.0 (0x00007f4e251d3000)',
'libheimbase.so.1 => /usr/lib/i386-linux-gnu/libheimbase.so.1 (0x00007f4e24fc4000)',
'libhx509.so.5 => /usr/lib/i386-linux-gnu/libhx509.so.5 (0x00007f4e24d78000)',
'libsqlite3.so.0 => /usr/lib/i386-linux-gnu/libsqlite3.so.0 (0x00007f4e24aab000)',
'libcrypt.so.1 => /lib/i386-linux-gnu/libcrypt.so.1 (0x00007f4e24873000)');

my @reqlist2 = ('linux-vdso.so.1 =>  (0x00007ffe42bf1000)',
'librt.so.1 => /lib/i386-linux-gnu/librt.so.1 (0x00007f63d80fe000)',
'libcurl-gnutls.so.4 => /usr/lib/i386-linux-gnu/libcurl-gnutls.so.4 (0x00007f63d7e9c000)',
'libsqlite3.so.0 => /usr/lib/i386-linux-gnu/libsqlite3.so.0 (0x00007f63d7be3000)',
'libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0x00007f63d79c5000)',
'libuuid.so.1 => /lib/i386-linux-gnu/libuuid.so.1 (0x00007f63d77c0000)',
'libblkid.so.1 => /lib/i386-linux-gnu/libblkid.so.1 (0x00007f63d759a000)',
'libgcrypt.so.11 => /lib/i386-linux-gnu/libgcrypt.so.11 (0x00007f63d731a000)',
'libgnutls.so.26 => /usr/lib/i386-linux-gnu/libgnutls.so.26 (0x00007f63d705c000)',
'libmicrohttpd.so.10 => /usr/lib/i386-linux-gnu/libmicrohttpd.so.10 (0x00007f63d6e45000)',
'libstdc++.so.6 => /usr/lib/i386-linux-gnu/libstdc++.so.6 (0x00007f63d6b41000)',
'libm.so.6 => /lib/i386-linux-gnu/libm.so.6 (0x00007f63d683b000)',
'libgcc_s.so.1 => /lib/i386-linux-gnu/libgcc_s.so.1 (0x00007f63d6625000)',
'libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0x00007f63d6260000)',
'libidn.so.11 => /usr/lib/i386-linux-gnu/libidn.so.11 (0x00007f63d602d000)',
'librtmp.so.0 => /usr/lib/i386-linux-gnu/librtmp.so.0 (0x00007f63d5e13000)',
'libgssapi_krb5.so.2 => /usr/lib/i386-linux-gnu/libgssapi_krb5.so.2 (0x00007f63d5bcd000)',
'liblber-2.4.so.2 => /usr/lib/i386-linux-gnu/liblber-2.4.so.2 (0x00007f63d59be000)',
'libldap_r-2.4.so.2 => /usr/lib/i386-linux-gnu/libldap_r-2.4.so.2 (0x00007f63d576d000)',
'libz.so.1 => /lib/i386-linux-gnu/libz.so.1 (0x00007f63d5554000)',
'libdl.so.2 => /lib/i386-linux-gnu/libdl.so.2 (0x00007f63d5350000)',
'/lib64/ld-linux-x86-64.so.2 (0x00007f63d8306000)',
'libgpg-error.so.0 => /lib/i386-linux-gnu/libgpg-error.so.0 (0x00007f63d514b000)',
'libtasn1.so.6 => /usr/lib/i386-linux-gnu/libtasn1.so.6 (0x00007f63d4f37000)',
'libp11-kit.so.0 => /usr/lib/i386-linux-gnu/libp11-kit.so.0 (0x00007f63d4cf5000)',
'libkrb5.so.3 => /usr/lib/i386-linux-gnu/libkrb5.so.3 (0x00007f63d4a2a000)',
'libk5crypto.so.3 => /usr/lib/i386-linux-gnu/libk5crypto.so.3 (0x00007f63d47fb000)',
'libcom_err.so.2 => /lib/i386-linux-gnu/libcom_err.so.2 (0x00007f63d45f7000)',
'libkrb5support.so.0 => /usr/lib/i386-linux-gnu/libkrb5support.so.0 (0x00007f63d43ec000)',
'libresolv.so.2 => /lib/i386-linux-gnu/libresolv.so.2 (0x00007f63d41d1000)',
'libsasl2.so.2 => /usr/lib/i386-linux-gnu/libsasl2.so.2 (0x00007f63d3fb6000)',
'libgssapi.so.3 => /usr/lib/i386-linux-gnu/libgssapi.so.3 (0x00007f63d3d78000)',
'libffi.so.6 => /usr/lib/i386-linux-gnu/libffi.so.6 (0x00007f63d3b70000)',
'libkeyutils.so.1 => /lib/i386-linux-gnu/libkeyutils.so.1 (0x00007f63d396c000)',
'libheimntlm.so.0 => /usr/lib/i386-linux-gnu/libheimntlm.so.0 (0x00007f63d3763000)',
'libkrb5.so.26 => /usr/lib/i386-linux-gnu/libkrb5.so.26 (0x00007f63d34db000)',
'libasn1.so.8 => /usr/lib/i386-linux-gnu/libasn1.so.8 (0x00007f63d323a000)',
'libhcrypto.so.4 => /usr/lib/i386-linux-gnu/libhcrypto.so.4 (0x00007f63d3007000)',
'libroken.so.18 => /usr/lib/i386-linux-gnu/libroken.so.18 (0x00007f63d2df2000)',
'libwind.so.0 => /usr/lib/i386-linux-gnu/libwind.so.0 (0x00007f63d2bc9000)',
'libheimbase.so.1 => /usr/lib/i386-linux-gnu/libheimbase.so.1 (0x00007f63d29bb000)',
'libhx509.so.5 => /usr/lib/i386-linux-gnu/libhx509.so.5 (0x00007f63d2772000)',
'libcrypt.so.1 => /lib/i386-linux-gnu/libcrypt.so.1 (0x00007f63d2539000)');

  #print Dumper('<<<',@reqlist);
  print Dumper('<<<',@reqlist2);

  # Get the list of libs provided by this package.  Still doesn't
  # handle the case where the lib gets stuffed into a subpackage.  :/
  #my @intprovlist = qx ( find $pkgtree -type f -name "*.so*" -printf "%P\n" );

  my @reqliblist;
  foreach (@reqlist2) {
    next if /not a dynamic executable/;
    next if m|/lib(?:64)?/ld-linux|;	# Hack! Hack!  PTHBTT!  (libc suxx0rz)
    next if /linux-(gate|vdso).so/;	# Kernel hackery for teh W1n!!1!1eleventy-one!1  (Don't ask.  Feh.)

    # Whee!  more hackery to detect provided-here libs.  Some apparently return from ldd as "not found".
    my ($a,$b) = split / => /;
    $a =~ s/\s//g;
    if ($b =~ /not found/) {
	    #next if qx ( find $specglobals{buildroot} -name "*$a" );
    }

    my ($req) = m|=\>\s+([\w./+-]+)|; # dig out the actual library (so)name.
	# And feh, we need the *path*, since I've discovered a new edge case where
	# the same libnnn.1.2.3 *file*name is found across *several* lib dirs.  >:(

    # Ignore libs provided by this package.  Note that we don't match
    # on word-boundary at the *end* of the lib we're looking for, as the
    # looked-for lib may not have the full soname version. (ie, it may
    # "just" point to one of the symlinks that get created somewhere.)
    #next if grep { /\b$req/ } @intprovlist;

    push @reqliblist, $req;
  }

  print Dumper('===',@reqliblist);

# For now, we're done.  We're not going to meddle with versions yet.
# Among other things, it's messier than handling "simple" yes/no "do
# we have this lib?" deps.  >:(

=pod
  # Original version
  return map { qx(dpkg-query -S $_) =~ /([\w.-]+?):/ } @reqliblist;

  # Intermediate version
  my @res = map {
    my $in = $_;
    my $res = qx(dpkg-query -S $_);
    $res =~ /(\S+?):/;
    print "<<<$in($res)>>>\n" if $res eq '0';
    $res;
  } @reqliblist;
  print Dumper('>>>',@res);
  return @res;
=cut
#print Dumper('<<<',@reqliblist);
  my $in = join(' ',@reqliblist);
#print Dumper('===',$in);
#  my $res = qx(dpkg-query -S $in);
#print Dumper('+++',$res);
#  my @out = $res =~ m/(\S+?):/g;
#print Dumper('>>>',@out);
#  return @out;
return qx(dpkg-query -S $in) =~ m/^(\S+?):/g;

} # end getreqs()

my @requires = getreqs();

print Dumper(@requires);
