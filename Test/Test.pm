package Lufs::Test;

# this package runs _outside_ of lufsd

use strict;
use File::Temp qw/tempdir/;

sub new {
	my $cls = shift;
	my $self = {
		fs => shift || 'Lufs::Stub',
		root => shift || '/',
		tmpdir => tempdir,
	};
	bless $self => $cls;
}

sub mount {
	my $self = shift;
	my $fs = $self->{fs};
	my $root = $self->{root};
	$fs =~ s/::/./g;
	$root =~ s{^/+}{}g;
	system("lufsmount -c 1 perlfs://$fs/$root $self->{tmpdir}")?0:1;
}

sub mounted {
	my $self = shift;
	my $f;open($f,"< /etc/mtab");
	scalar grep /\Q$self->{tmpdir}\E/, (<$f>);
}

sub umount {
	my $self = shift;
	system("lufsumount $self->{tmpdir}") if $self->mounted;
}

sub DESTROY {
	my $self = shift;
	$self->umount;
	rmdir($self->{tmpdir});
}
1;

