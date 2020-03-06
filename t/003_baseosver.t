use strict;
use warnings;
use File::Basename;

use Test::More tests => 4;

my $scriptdir = dirname(__FILE__);

my $home = $ENV{HOME};

my $os_id = `cat /etc/os-release`;
$os_id =~ /^ID="?(\w+)"?/m;
$os_id = $1;

my $os_seen = `./debbuild.out --showrc`;
like($os_seen, qr/^%\Q$os_id\E ==> (\S+)/m, "os-release ID present");

my $testdir = $scriptdir . '/../testdir/baseosver';
local $ENV{HOME} = $testdir;
open my $f, '>', "$testdir/.debmacros" || die "Could not write test file .debmacros: $!";
print $f "%$os_id somethingsilly\n";
close $f;

my $test_os_seen = `./debbuild.out --showrc`;
$test_os_seen =~ /^%\Q$os_id\E ==> (\S+)/m;
is($1, "somethingsilly", ".debmacros overwrites /etc/os-release");

TODO: {
    todo_skip "make different /etc/os-release testable", 2;

    local $ENV{HOME} = $testdir . '/debian10';
    my $test_os_release = `./debbuild.out --showrc`;
    like($test_os_release, qr/^%debian_version 1000/m, "Debian 10.0 is picked up from os-release");

    local $ENV{HOME} = $testdir . '/debian_sid';
    $test_os_release = `./debbuild.out --showrc`;
    like($test_os_release, qr/^%debian_version 9999/m, "Debian sid is substituted");
}
