use Test2::V0;

plan 1;

chomp(my $version_string = `./debbuild --version`);
is($version_string, 'This is debbuild, version @VERSION@', 'Verify that debbuild --version runs');
