#!/usr/bin/perl -w
use strict;
use Lufs;
use Data::Dumper;
Lufs->new;
Lufs::C::_init("Lufs.Ram");
Lufs::C::mount();
Lufs::C::stat('/');
my $ref = [];
Lufs::C::readdir('/',$ref);
print Dumper($ref);$ref=[];
Lufs::C::mkdir('/dus',0755);
Lufs::C::readdir('/',$ref);
print Dumper($ref);$ref=[];
Lufs::C::create('/dus/hoere');
Lufs::C::readdir('/dus',$ref);
print Dumper($ref);$ref=[];
Lufs::C::unlink('/dus/hoere');
Lufs::C::readdir('/',$ref);
print Dumper($ref);$ref=[];
Lufs::C::rmdir('/dus');
Lufs::C::readdir('/',$ref);
print Dumper($ref);$ref=[];

