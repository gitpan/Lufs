package Lufs::Execfs;

use 'base' Lufs::Local;

use strict;

1;


=head1 NAME

Lufs::Execfs - A module that executes code from the underlying filesystem, with stdin/stdout connected to read() and write() calls

=head1 SYNOPSIS

lufsmount -c 1 perlfs://Lufs::Execfs/dir/with/code /mnt/exec
cat /mnt/exec/script.pl
# or even
lufsmount -c 1 perlfs://Lufs::Execfs/usr/bin /mnt/bin
cat /mnt/bin/ls
open($fh, "<> /mnt/bin/perl")
print $fh "more perl\n"
printf "perl said: %s\n", <$fh>;


=head1 ABSTRACT

Kind of like Apache::Registry, and a little like hurd.


