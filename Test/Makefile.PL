use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Lufs::Test',
    'VERSION_FROM'	=> '../Lufs.pm', # finds $VERSION
    'PREREQ_PM'		=> {},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
       (AUTHOR     => 'Raoul Zwart <rlzwart@cpan.org>') : ()),
);
