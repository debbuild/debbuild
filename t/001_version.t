use Test2::V0;

plan 1;

chomp(my $version_string = `./debbuild.out --version`);
like($version_string, qr/This is debbuild, version/, 'Verify that debbuild --version runs');
