use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Lufs::Benchmark',
    'VERSION_FROM'	=> '../Lufs.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
       (AUTHOR     => 'Raoul Zwart <rlzwart@cpan.org>') : ()),
);
