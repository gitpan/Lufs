package Lufs::Trans;

use strict;
use warnings;

use base 'Lufs::Local';

sub init {
    my $self = shift;
    $self->{fh}=[];
}

sub _clnhandles {
    my $self = shift;
    no warnings;
    $self->{fh} = [grep { sysseek($_->{handle},0,1) } @{$self->{fh}}];
}

sub _gethandle {
    my $self = shift;
    my $file = shift;
    my $mode = shift;
    $self->_clnhandles;
    if (my $h = [map { $_->{handle} } grep {$file eq $_->{file} and ($mode == $_->{mode} or $mode == 0xffff)}@{$self->{fh}}]->[0]) {
        return $h;
    }
    else {
        if (sysopen(FH,$file,$mode)) {
            my $fh = \*FH;
            push @{$self->{fh}}, {file => $file, mode => $mode, handle => $fh};
            return $fh;
        }
        return;
    }
}

sub open {
    my $self = shift;
    my ($file, $mode) = @_;
    if (defined $self->_gethandle($file,$mode)) { return 1 } else { return 0 }
}

sub release {
    my $self = shift;
    my $file = shift;
    my $fh = $self->_gethandle($file,0xffff) or return 0;
    close($fh);
    return 1;
}

sub read {
    my $self = shift;
    my $file = shift;
    my $offset = shift;
    my $count = shift;
    my $fh = $self->_gethandle($file,0) or return -1;
    sysseek($fh,$offset,0);
    my $cnt = sysread($fh,$_[0],$count);
    return defined($cnt)?$cnt:-1;
}

sub write {
    my $self = shift;
    my $file = shift;
    my ($offset, $count, $buf) = @_;
    my $fh = $self->_gethandle($file,1) or return -1;
    sysseek($fh,$offset,0);
    if (print($fh $buf)) { return $count }
    return -1;
}

sub umount {
    my $self = shift;
    $self->_cleanup;
}

sub _cleanup {
    my $self = shift;
    map { close($_->{handle}) } @{$self->{fh}};
    $self->_clnhandles;
}

sub DESTROY {
    my $self = shift;
    $self->_cleanup;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lufs::Trans - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Lufs::Trans;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for Lufs::Trans.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for Lufs::Trans, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

root, E<lt>root@internE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by root

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
