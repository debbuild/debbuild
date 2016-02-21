#!/usr/bin/perl

use strict;
use warnings;

use Text::Balanced qw(extract_bracketed extract_multiple);
use Data::Dumper;

## bracelet()
# Shortcut for extracting paired curly braces
sub bracelet {
  return extract_multiple($_, [ sub { extract_bracketed($_[0],'{}') } ]);
} # end bracelet()

my @macros = ('%apply_patch',
  q(test -f %{1} || exit 1;\
%{uncompress:%{1}} | %{expand:%{__scm_apply_%{__scm} %{-q} %{-p:-p%{-p*} -z .bak} %{-m:-m%{-m*}}}}));

my $macro = $macros[1];
my %options = ('p' => '1', 'm' => '/path/to/file0042.patch');

print "<<<<<<\n".Dumper($macro)."\n";

$_ = $macro;

my @result1 = bracelet();
print "Level 1\n".Dumper(@result1)."\n";

my @result2 = map { /{(.+)}/ } grep { /{.+}/ } @result1;
print "Level 2\n".Dumper(@result2)."\n";

foreach (@result2) {
  my @result3 = bracelet();
  next unless @result3;
  print "Level 3\n".Dumper(@result3)."\n";

  my @result4 = map { /{(.+)}/ } grep { /{.+}/ } @result3;
  next unless @result4;
  print "Level 4\n".Dumper(@result4)."\n";

  foreach (@result4) {
    while (my ($option,$repl) = map { /{-(\w):\s*(.+)}/ } bracelet() ) {
      print Dumper('+++',$option,$repl);
      (my $result = $options{$option} ? $repl : '') =~ s/%{-(\w)\*}/$options{$1}/g;
      $repl =~ s/([*{}])/\\$1/g; # mask Perlish special characters
print "---$_(".pos.")---\n";
      s/%{-$option:\s*$repl}/$result/g;
print "+++$_+++\n";
      $macro =~ s/%{-$option:\s*$repl}/$result/g;
    }
  }
}

print "\n>>>>>>\n".Dumper($macro);

exit 0;
