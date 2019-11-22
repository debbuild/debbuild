#!/usr/bin/perl

# Copyright (C) 2007-2010 Mandriva, S.A.
# Copyright (C) 2010-2017 Mageia
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use strict;
use warnings;
use File::Basename;

use Test::More qw(no_plan);

my $scriptdir = dirname(__FILE__);
my $testarbo = "/tmp/find-lang-root";


my %files = (
    # file => [ lang, is_%dir ]
    '/usr/share/man/fr' => [ 'fr', 1 ],
    '/usr/share/man/fr/man1' => [ 'fr', 1 ],
    '/usr/share/man/fr/man1/lang.1.*' => [ 'fr', 0 ],
    '/usr/share/locale/pt_BR' => [ 'pt_BR', 1 ],
    '/usr/share/gnome/help/lang/pt_BR' => [ 'pt_BR', 1 ],
    '/usr/share/gnome/help/lang/pt_BR/any.html' => [ 'pt_BR', 0 ],
    '/usr/share/gnome/help/lang/en_GB' => [ 'en_GB', 1 ],
    '/usr/share/gnome/help/lang/en_GB/any.html' => [ 'en_GB', 0 ],
    '/usr/share/gnome/help/lang' => [ '', 1 ],
    '/usr/share/locale/pt_BR/LC_MESSAGES' => [ 'pt_BR', 1 ],
    '/usr/share/locale/pt_BR/LC_MESSAGES/lang.mo' => [ 'pt_BR', 0 ],
);


system("$scriptdir/findlang-prep.sh") and die "can't prepare for test";
system("$scriptdir/../scripts/find-lang.pl $testarbo lang --with-man --with-gnome") and die "can't run find-lang $@";

open(my $h, '<', 'lang.lang') or die "can't open lang.lang";

while (my $line = <$h>) {
    chomp($line);
    $line =~ /svn/ and next;
    my @parts = split(' ', $line);
    my $file = $parts[-1];
    my $dir = $line =~ /%dir/;
    $dir ||= 0;
    print STDERR "$file\n";
    is($dir, $files{$file}[1], "%dir is properly set if need");
}

