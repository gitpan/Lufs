package Lufs::Glue;
$|++;
BEGIN { open(OLDERRZ,"&>STDERR");open(STDERR,">>/tmp/perlufs");close OLDERRZ }

#END { close STDERR;open(STDERR,"&>OLDERRZ");close OLDERRZ }

sub TRACE {
    print STDERR "$_[1]\n";
}

sub TRACEx {
    my $self = shift;
    my $msg = shift;
    open(ERR,">>/tmp/perlufs") or return;
    print ERR "$msg\n";
    close ERR;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lufs::Glue - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Lufs::Glue;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for Lufs::Glue.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for Lufs::Glue, created by h2xs. It looks like the
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
