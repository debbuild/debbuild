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

foreach ( map { /{(.+)}/ } grep { /{.+}/ } bracelet() ) {

  foreach ( map { /{(.+)}/ } grep { /{.+}/ } bracelet() ) {

    while (my ($option,$repl) = map { /{-(\w):\s*(.+)}/ } bracelet() ) {
      print Dumper('+++',$option,$repl);
      (my $result = $options{$option} ? $repl : '') =~ s/%{-(\w)\*}/$options{$1}/g;
      $repl =~ s/([*{}])/\\$1/g; # mask Perlish special characters
print "---$_(".pos.")---\n";
      s/%{-$option:\s*$repl}/$result/g;
print "+++$_+++\n";
      $macro =~ s/%{-$option:\s*$repl}/$result/g;
    }
    pos = 0; # reset to start of $_
    while (my ($option) = map { /{-(\w)(?:\*)?}/ } bracelet() ) {
      print Dumper('+++',$option);
      my $result = $options{$option} ? "-$option" : '';
print "---$_(".pos.")---\n";
      s/%{-$option}/$result/g;
      $macro =~ s/%{-$option}/$result/g;
print "---$_---\n";
      s/%{-($option)\*}/$options{$1}/g;
      $macro =~ s/%{-($option)\*}/$options{$1}/g;
print "+++$_+++\n";
    }
  }
}

print "\n>>>>>>\n".Dumper($macro);

exit 0;
