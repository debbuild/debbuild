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
  'test -f %{1} || exit 1;\\'.
  '%{uncompress:%{1}} | %{expand:%{__scm_apply_%{__scm} %{-q} %{-p:-p%{-p*} -z .bak} %{-m:-m%{-m*}}}}');

$_ = $macros[1];

my @result = bracelet();
print "Level 1\n".Dumper(@result)."\n";

my @result2 = grep { /{\w+:.*}/ } @result;
print "Level 2\n".Dumper(@result2)."\n";

my @result3 = map { /{\w+:(.+)}/ } @result2;
print "Level 3\n".Dumper(@result3)."\n";

my @result4 = grep { /{\S+\s+.+}/ } @result3;
print "Level 4\n".Dumper(@result4)."\n";

my @result5 = map { /{(.*)}/ } @result4;
print "Level 5\n".Dumper(@result5)."\n";

$_ = $result5[0];

my @result6 = bracelet();
print "Level 6\n".Dumper(@result6)."\n";

my @result7 = grep { /{-\w.*}/ } @result6;
print "Level 7\n".Dumper(@result7)."\n";

exit 0;
