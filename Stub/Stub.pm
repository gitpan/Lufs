package Lufs::Stub;

sub init {
    my $self = shift;
    my $arg = shift;

    return 1;
}

sub AUTOLOAD {
    my $self = shift;
    my $method = (split/::/,$AUTOLOAD)[-1];
    $method eq 'DESTROY' && return;
    $self->TRACE("$method not implemented: $_[0]");
    0;
}

#####################################
############# lufs calls ############
#####################################

sub mount {
    my $self = shift;
    return 1;
}

sub umount { 
    my $self = shift;
    return 1;
}

sub stat {
    my $self = shift;
    my $file = shift;
    $file =~ s{/\.$}{/};
    my $ref = shift;
    if ($file eq '/') {
        $ref->{f_ino} = 1;
        $ref->{f_mode} = 0040000 | 0755;
        $ref->{f_nlink} = 1;
        $ref->{f_uid} = 0;
        $ref->{f_gid} = 0;
        $ref->{f_size} = 2048;
        $ref->{f_atime} = time;
        $ref->{f_mtime} = time;
        $ref->{f_ctime} = time;
        $ref->{f_blksize} = 512;
        $ref->{f_blocks} = 4;
        return 1;
    }
    elsif ($file =~ /(hello|world)/) {
        $ref->{f_ino} = $file eq 'hello'?2:3;
        $ref->{f_mode} = 0100000 | 0666;
        $ref->{f_nlink} = 1;
        $ref->{f_uid} = 1;
        $ref->{f_gid} = 1;
        $ref->{f_size} = 4096;
        $ref->{f_atime} = time;
        $ref->{f_mtime} = time;
        $ref->{f_ctime} = time;
        $ref->{f_blksize} = 512;
        $ref->{f_blocks} = 8;
        return 1;
    }
    return 0;
}

sub readdir {
    my $self = shift;
    my $dir = shift;
    my $ref = shift;
    if ($dir eq '/') {
        push @{$ref}, qw/hello world/;
    }
}

sub mkdir {
    my $self = shift;
    my $dir = shift;
    my $mode = shift;
    return -1;
}

sub open {
    my $self = shift;
    my ($file,$mode) = @_;
    if ($file =~ /(hello|world)/) {
        return 1;
    }
    return 0;
}

sub read {
    my $self = shift;
    my $file = shift;
    my $offset = shift;
    my $count = shift;
    unless ($file =~ /(hello|world)/) { return 0 }
    if ($offset > 4096) { return 0 }
    $_[0] = "$1 "x($count/6);
    return $count;
}

sub release {
    my $self = shift;
    my ($file) = shift;
    return 1;
}

sub write {
    my $self = shift;
    my ($file, $offset, $count, $buf) = @_;
    return length($buf);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lufs::Stub - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Lufs::Stub;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for Lufs::Stub.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for Lufs::Stub, created by h2xs. It looks like the
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
