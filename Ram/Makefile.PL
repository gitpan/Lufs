use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Lufs::Ram',
    'VERSION_FROM'	=> '../Lufs.pm',
    'PREREQ_PM'		=> {},
    ($] >= 5.005 ?
       (AUTHOR     => 'root <root@intern>') : ()),
);
