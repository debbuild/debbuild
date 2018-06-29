#!/usr/bin/perl -w

use strict;
use warnings;

use Data::Dumper;

my %optflags = ('all' => '');

## config_debrc()
# Load default configuration similar to RPM which digests global configuration
# /usr/lib/rpm/rpmrc, per-system configuration /etc/rpmrc and per-user
# configuration ~/.rpmrc. ATTOW, only 'optflags' are loaded.
sub config_debrc {
  # Load default configuration, permitting local override
  my $homedir = $ENV{HOME} // $ENV{LOGDIR} // (getpwuid($<))[7];
  foreach my $macros ( ('/usr/lib/debbuild/debrc',
                        '/etc/debrc',
                        "$homedir/.debrc") ) {
    open MACROS,$macros or next; # should we warn about missing macro files?
    while (<MACROS>) {
      next unless my ($flag,$value) = /^optflags:\s+(\w+)\s+(.+)$/;
      $optflags{$flag} = $value;
    }
    close MACROS;
  }
} # end config_debrc()

### main ###

config_debrc();

print Dumper(%optflags);

exit 0;
