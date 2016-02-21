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

    replace_options();

  }

  replace_options();

}

print "\n>>>>>>\n".Dumper($macro);

exit 0;

## replace_options()
# Expand all '%{-o:ptions}' and '%{-o}ptions' in '$_'.
sub replace_options {
  while (my ($option,$repl) = map { /{-(\w):\s*(.+)}/ } bracelet() ) {
    print Dumper('+1+',$option,$repl);
    (my $result = $options{$option} ? $repl : '') =~ s/%{-(\w)\*}/$options{$1}/g;
    $repl =~ s/([*{}])/\\$1/g; # mask Perlish special characters
print "-1-$_(".pos.")-1-\n";
    s/%{-$option:\s*$repl}/$result/g;
print "+1+$_+1+\n";
    $macro =~ s/%{-$option:\s*$repl}/$result/g;
print "+1+$macro+1+\n";
  }
  pos = 0; # reset to start of $_
  while (my ($option) = map { /{-(\w)(?:\*)?}/ } bracelet() ) {
    print Dumper('+2+',$option);
    my $result = $options{$option} ? "-$option" : '';
print "-2-$_(".pos.")-2-\n";
    s/%{-$option}/$result/g;
    $macro =~ s/%{-$option}/$result/g;
print "-2-$_-2-\n";
    s/%{-($option)\*}/$options{$1}/g;
print "+2+$_+2+\n";
    $macro =~ s/%{-($option)\*}/$options{$1}/g;
print "+2+$macro+2+\n";
  }
} # end replace_options()
