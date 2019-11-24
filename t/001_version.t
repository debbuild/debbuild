use Test2::V0;

plan 1;

my $script_path = './makecheck/bin/debbuild';
-x $script_path  or bail_out("Unable to find $script_path . Run tests under 'make check' to generate it");

chomp(my $version_string = `$script_path --version`);
like($version_string, qr/This is debbuild, version/, 'Verify that debbuild --version runs');
