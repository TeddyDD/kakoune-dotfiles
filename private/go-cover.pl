#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

chomp(my $mod = `go list -m`);
my $file = $ENV{KAK_BUFFILE};
my $faces = $ENV{FACES};
my @faces = split(/\|/, $faces);

my @res;

while (<>) {
    # name.go:line.column,line.column numberOfStatements count
	if ($_ =~ /^${mod}\/${file}:(\d+\.\d+,\d+\.\d+)\s([^0]\d*)\s(\d+)/) {
		my $count = $3;
		my $range = "$1";
		if ($count > 0) {
    		$range = $range . "|$faces[1]";
		} else {
    		$range = $range . "|$faces[0]";
		}
		push @res, "'$range'";
	}

}

print join " ", @res;
