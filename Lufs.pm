package Lufs;

use base 'Lufs::Glue';
use Lufs::C;

use strict;
use warnings;
our $VERSION = 0.13;

use vars qw/$AUTOLOAD/;

sub new {
    my $cls = shift;
    my $self = {};
    bless $self => $cls;
    $Lufs::C::object = $self;
}

sub _init {
    my $self = shift;
    my $opt = pop;
    my ($f, $class) = ($opt->{host}, $opt->{host});
    $f =~ s{\.}{/}g;$f .= '.pm';
    $class =~ s{\.}{::}g;
    eval "require '$f'";
    if ($@) { warn "cannot load class: $@"; return 0 }
    eval 'push @'.$class."::ISA, 'Lufs::Glue'";
    $self->{fs} = bless {} => $class;
	open(STDERR, ">> $opt->{logfile}") if $opt->{logfile};
	$Lufs::Glue::trace = 1 if $opt->{logfile};
    $self->{fs}->init($opt);
}

sub AUTOLOAD {
    my $self = shift;
    my $method = (split/::/,$AUTOLOAD)[-1];
    $method eq 'DESTROY' && return;
    $self->{fs}->$method(@_);
}

1;
__END__

=head1 NAME

Lufs - Perl plug for lufs

=head1 DESCRIPTION

  The C code is a lufs module with an embedded perl interpreter;
  All filesystem calls are redirected to Lufs::C, which in turn gives them to your subclass;

  currently, these filesystems have been implemented:

  Lufs::Stub - A hello world fs, look here for an introduction to the api
  Lufs::Local - Like localfs in lufs, a transparent fs
  Lufs::Ram - Ramfs
  Lufs::Trans - emulates filehandles on top of sequential reads/writes

  lufsmount -c 1 perlfs://Lufs.Stub/ /mnt/perl
  lufsmount -c 1 -o logfile=/tmp/perlfslog perlfs://Lufs.Local/ /mnt/foo
  lufsmount -c 1 -o maxsize=20m perlfs://Lufs.Ram/ /mnt/bar
  lufsmount -c 1 perlfs://Lufs.Trans/ /mnt/baz
  # or, if you have autofs:
  cd /mnt/perl/root@Lufs.Stub/
  
=head1 SEE ALSO

  http://lufs.sf.net
  lufsmount(1)

=head1 AUTHOR

Raoul Zwart, E<lt>rlzwart@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Raoul Zwart

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
