use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Lufs',
    'VERSION_FROM'	=> 'Lufs.pm',
    ($] >= 5.005 ?
       (AUTHOR     => 'Raoul Zwart <rlzwart@cpan.org>') : ()),
);

print "Don't forget to `make; make install' in ./perlfs\n";
