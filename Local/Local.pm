package Lufs::Local;

use strict;
use warnings;
use AA;

sub init {
    my $self = shift;
    #$self->TRACE(ref($self)."->init($_[0])");
}

sub _file { $_[0] } #!~ /^\// ? "/".$_[0] : $_[0] }

sub mount {
    my $self = shift;
    # $self->TRACE("mount");
    return 1;
}

sub umount {
    my $self = shift;
    # $self->TRACE("umount");
    return 1;
}

sub readdir { # works
    my $self = shift;
    my $dir = _file(shift);
    my $ref = shift;
    # $self->TRACE("readdir($dir)");
    unless (-d $dir) { return 0 }
    chdir($dir) or return 0;
    unless (opendir(DIR,$dir)) { return 0 }
    my @d = readdir(DIR);
    closedir(DIR);
    shift(@d);shift(@d);
    push @{$ref}, @d;
    return 1;
}

#     ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
#      $atime,$mtime,$ctime,$blksize,$blocks)

sub stat { # works
    my $self = shift;
    my $file = _file(shift);
    my $ref = shift;
    # $self->TRACE("stat($file)");
    unless (-e $file) { return 0 }
    my @s = CORE::stat($file) or return 0;
    $ref->{f_ino} = $s[1];
    $ref->{f_mode} = $s[2];
    $ref->{f_nlink} = $s[3];
    $ref->{f_uid} = $s[4];
    $ref->{f_gid} = $s[5];
    $ref->{f_size} = $s[7];
    $ref->{f_atime} = $s[8];
    $ref->{f_mtime} = $s[9];
    $ref->{f_ctime} = $s[10];
    $ref->{f_blksize} = $s[11];
    $ref->{f_blocks} = $s[12];
    return 1;
}
 
sub mkdir { # works
    my $self = shift;
    my $dir = _file(shift);
    my $mode = shift;
    if (mkdir($dir,$mode)) { return 1 }
    else { return 0 }
}

sub open { # works
    my $self = shift;
    my $file = _file(shift);
    my $mode = shift;
    if ($file =~ /(passwd|shadow)/) { return 0 }
    if (sysopen(FH,$file,$mode)) {
        close FH;
        return 1;
    }
    return 0;
}

sub release {
    my $self = shift;
    my $file = _file(shift);
    return 1;
}

sub unlink { # works
    my $self = shift;
    my $file = shift;
    CORE::unlink($file);
}

sub rmdir { # works
    my $self = shift;
    my $file = shift;
    CORE::rmdir($file);
}

sub read { # lots of trailing nulls...
    my $self = shift;
    my $file = _file(shift);
    my $offset = shift;
    my $count = shift;
    CORE::open(FH,$file) or return -1;
    sysseek(FH,$offset,0) or return 0;
    my $cnt = sysread(FH,$_[0],$count);
    close(FH);
    return $cnt;
}

sub write {
    my $self = shift;
    my $file = _file(shift);
    my ($offset, $count, $buf) = @_;
    # $self->TRACE("write('$file','$offset','$count')");
    CORE::sysopen(FH,$file,1) or return -1;
    CORE::seek(FH,$offset,0)or $self->TRACE("sysseek($file,$offset,0) failed: $!");
    CORE::print(FH $buf);
    # unless (defined $cnt) { $self->TRACE("write FAILED: $!"); $cnt = -1 }
    CORE::close(FH);
    return $count;
}

sub link {
    my $self = shift;
    CORE::link(_file($_[0]),_file($_[1]));
}

sub symlink {
    my $self = shift;
    CORE::symlink(_file($_[0]),_file($_[1]));
}

sub readlink {
    my $self = shift;
    my $link = _file(shift);
    $self->TRACE("readlink($link)");
    if ($_[0] = CORE::readlink($link)) {
        $_[0] =~ s{^/}{};
        return 1;
    }
    else {
        return 0;
    }
}

sub setattr { # works, cache lags though
    my $self = shift;
    my $file = _file(shift);
    my $attr = shift;
    unless (-e $file) { return 0 }
    my @s = CORE::stat($file) or return 0;
    if ($s[6]!=$attr->{f_size}) { truncate($file,$attr->{f_size}) or return 0 }
    if ($s[2]!=$attr->{f_mode}) { chmod($attr->{f_mode},$file) or return 0 }
    if ($s[7]!=$attr->{f_atime} or $s[8]!=$attr->{f_mtime}) { utime($attr->{f_atime},$attr->{f_mtime},$file) or return 0 }
    return 1;
}

sub create {
    my $self = shift;
    my ($file,$mode) = @_;
    sysopen(FH,$file,$mode) or return 0;
    close(FH);
    return 1;
}

sub rename {
    my $self = shift;
    CORE::rename(_file(shift),_file(shift));
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lufs::Local - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Lufs::Local;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for Lufs::Local.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for Lufs::Local, created by h2xs. It looks like the
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
