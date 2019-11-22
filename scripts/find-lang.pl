#!/usr/bin/perl

# findlang - automagically generate list of language specific files for inclusion in an rpm spec file
# This does assume that the *.mo files are under .../locale/...
# Perl version inspired by original shell one in rpm

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
use File::Find;
use Getopt::Long;
use Pod::Usage;

GetOptions(
    'all-name'   => \my $allname,
    'with-gnome' => \my $withgnome,
    'with-help'  => \my $withhelp,
    'with-kde'   => \my $withkde,
    'with-html'  => \my $withhtml,
    'without-mo' => \my $withoutmo,
    'with-man' => \my $withman,
    'debug' =>  \my $debug,
) or pod2usage();

my ($buildroot, @searchname) = @ARGV;
$buildroot or die "No buildroot given\n";
$buildroot =~ s!/+$!!; # removing trailing /
my ($pkgname) = @searchname or die "Main name to find missing\n";

sub debug {
    $debug or return;
    my ($msg, @val) = @_;
    printf("DEBUG: $msg\n", @val);
}

my %finallist; # filename => attr, easy way to perform uniq

File::Find::find(
    sub {
        my $file = substr($File::Find::name, length($buildroot));
        -f $File::Find::name or -l $File::Find::name or return;
        debug("next file is %s", $file);
        if ($file =~ m!^((.*/share/locale)/([^/@]+)[^/]*).*/([^/]+)\.mo!) {
            return if $withoutmo;
            my ($pkg, $lang) = ($4, $3);
	    own_file($file, $lang) if pkg_match($pkg);
        } elsif ($file =~ m!^((.*/gnome/help)/([^/]+)/([^/]+))!) {
            return if !$withgnome;
            my ($pkg, $lang, $langfile) = ($3, $4, $1);
            parent_to_own($langfile, $file, $lang) if pkg_match($pkg);
	} elsif ($file =~ m!^((.*/share/help)/([^/]+)/([^/]+))/([^/]+)!) {
	    return if !$withhelp;
	    my ($pkg, $lang, $langfile) = ($4, $3, $1);
	    parent_to_own($langfile, $file, $lang) if pkg_match($pkg);
        } elsif ($file =~ m!^((.*/doc/kde)/HTML/([^/@]+)[^/]*)/([^/]+)/!) {
            return if !$withkde;
            my ($pkg, $lang, $langfile) = ($4, $3, $1);
            parent_to_own($langfile, $file, $lang) if pkg_match($pkg);
        } elsif ($file =~ m!^((.*/doc)/HTML/([^/@]+)[^/]*)/([^/_]+)!) {
            return if !$withhtml;
            my ($pkg, $lang, $langfile) = ($4, $3, $1);
            parent_to_own($langfile, $file, $lang) if pkg_match($pkg);
        } elsif ($file =~ m!^((/+usr/share/man)/([^/@.]+)[^/]*)/man[^/]+/([^/]+)\.\d[^/]*!) {
            return if !$withman;
            my ($pkg, $lang, $langfile) = ($4, $3, $1);
            $file =~ s/\.[^\.]+$/.*/;
            own_file($file, $lang) if pkg_match($pkg);
        } else {
            return;
        }
    },
    $buildroot || '/'
);

open(my $hlang, '>', "$pkgname.lang") or die "cannot open $pkgname.lang\n";

foreach my $f (sort keys %finallist) {
    my ($lang, @otherlang) = keys %{ $finallist{$f}{lang} || {} };
    my $l = sprintf("%s%s%s",
        $finallist{$f}{dir} ? '%dir ' : '',
        @otherlang == 0 && $lang && $lang ne 'C'
            ? "%lang($lang) "
            : '', # skip if multiple lang, 'C' or dir
        $f
    );
    debug('OUT: %s', $l);
    print $hlang "$l\n";

}

close($hlang);

exit(0);

sub pkg_match {
    my ($pkg) = @_;
    return 1 if $allname;
    return 1 if grep { $_ eq $pkg } @searchname;
    return;
}

sub own_file {
    my ($file, $lang) = @_;
    $finallist{$file}{lang}{$lang} = 1;
}

sub parent_to_own {
    my ($parent, $file, $lang) = @_;
    debug("parent_to_own: $parent, $file, $lang");
    if ($allname) {
        #my @subdir = grep { $_ } split('/', substr($file, length($parent)));
        #$parent .= '/' . shift @subdir;
        $finallist{$parent}{lang}{$lang} = 1;
        debug("Parent %s will be %s", $parent, $lang);
    } else {
	my @subdir = grep { $_ } split('/', substr($file, length($parent)));
	pop @subdir;
	$finallist{$parent}{dir} = 1;
	$finallist{$parent}{lang}{$lang} = 1;
	debug("Parent %s will be %s", $parent, $lang);
	while (my $part = shift @subdir) {
	    $parent .= "/$part";
	    $finallist{$parent}{dir} = 1;
	    $finallist{$parent}{lang}{$lang} = 1;
	    debug("Parent %s will be %s", $parent, $lang);
	}
        own_file($file, $lang);
        debug("Parent %s will be %s", $file, $lang);

    }
}
