package Lufs::Benchmark;

our $largefile = '/data/grootfsNIETWEGGOOIEN';

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
    elsif ($file =~ /^(?:large)$/) {
        $ref->{f_ino} = $file eq 'large'?2:3;
        $ref->{f_mode} = 0100000 | 0666;
        $ref->{f_nlink} = 1;
        $ref->{f_uid} = 1;
        $ref->{f_gid} = 1;
        $ref->{f_size} = -s $largefile;
        $ref->{f_atime} = time;
        $ref->{f_mtime} = time;
        $ref->{f_ctime} = time;
        $ref->{f_blksize} = 512;
        $ref->{f_blocks} = int(-s $largefile / 512);
        return 1;
    }
    return 0;
}

sub readdir {
    my $self = shift;
    my $dir = shift;
    my $ref = shift;
    if ($dir eq '/') {
        push @{$ref}, 'large';
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
	$self->{_cnt} = 0;
	$self->{_tm} = time;
    my ($file,$mode) = @_;
    if ($file =~ /\/?(?:large)$/ and -f $largefile and -r $largefile) {
        return 1;
    }
    return 0;
}

sub read {
    my $self = shift;
    my $file = shift;
    my $offset = shift;
    my $count = shift;
    unless ($file =~ /\/?(large)$/) { return 0 }
	if ($offset > -s $largefile) { return 0 }
    my $fh;
	CORE::open($fh, "<", $largefile) or (print(STDERR "couldnt open $largefile\n"),return -1);
	seek($fh,$offset,0);
	my $c = read($fh,$_[0],$count);
	$self->{_cnt} += $c;
	$;
}

sub release {
    my $self = shift;
    my ($file) = shift;
	my $d = time() - delete $self->{_tm};
	$self->TRACE("closing file, $self->{_cnt} bytes in $d seconds");
    return 1;
}

sub write {
    my $self = shift;
    my ($file, $offset, $count, $buf) = @_;
    return length($buf);
}

1;
__END__

=head1 NAME

Lufs::Benchmark - A hello-world filesystem for use with perlufs

=head1 DESCRIPTION

 This is a hello world filesystem. 
 It contains two files: `hello' and `world'. Both files contain 4096 bytes.

=head1 AUTHOR

Raoul Zwart, E<lt>rlzwart@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Raoul Zwart

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
