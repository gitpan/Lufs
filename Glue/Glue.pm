package Lufs::Glue;
$|++;

our $trace = 0;

our %m = (
          '131072' => 'O_NOFOLLOW',
          '128' => 'O_EXCL',
          '512' => 'O_TRUNC',
          '2048' => 'O_NONBLOCK',
          '3' => 'O_ACCMODE',
          '1024' => 'O_APPEND',
          '64' => 'O_CREAT',
          '32768' => 'O_LARGEFILE',
          '16384' => 'O_DIRECT',
          '2' => 'O_RDWR',
          '65536' => 'O_DIRECTORY',
          '1' => 'O_WRONLY',
          '4096' => 'O_RSYNC',
          '8192' => 'O_ASYNC',
          '256' => 'O_NOCTTY'
        );

sub TRACE {
	my $self = shift;
	my $method = shift;
	return unless $trace;
	my (@arg) = @_;
	my $ret = pop(@arg);
	if ($method eq 'create') {
		$arg[1] = $self->mode($arg[1]);
	}
	if ($method eq 'stat') {
		$arg[1] = $self->hashdump($arg[1]);
	}
	if ($method eq 'write' or $method eq 'read') {
		$arg[3] = $self->_truncdata($arg[3]);
	}
	if ($method eq '_init') {
		$arg[0] = $self->hashdump($arg[0]);
	}
	$arg[0] = "'$arg[0]'";
    print STDERR "$method (".join(', ', @arg).") = $ret\n";
}

sub _truncdata {
	my $self = shift;
	my $data = shift;
	no warnings;
	my $s = (length$data>32)?"...":'';
	"'".substr($data, 0, 32)."'$s";
}

sub modes { # this generates the %m hash
	my $self = shift;
	my %m;
	for (grep /^[O]/, keys %{Fcntl::}) {
		my $v = eval "Fcntl::$_";
		next unless (int($v) eq $v);
		$m{$v} = $_ if $v;
	}
	%m;
}

sub mode {
	my $self = shift;
	my $mode = shift || Fcntl::O_CREAT | Fcntl::O_LARGEFILE;
	my @m;
	for (keys %m) {
		if (($mode & $_) == $_) {
			push @m, $m{$_};
		}
	}
	join(' | ', @m);
}

sub hashdump {
	my $self = shift;
	my $h = shift;
 	'{ '.join(', ', map { "$_ => $h->{$_}" } keys %{$h}).'}';
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lufs::Glue - misc subs

=head1 SYNOPSIS

  use base 'Lufs::Glue';
  $self->foo

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
