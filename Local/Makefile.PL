use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Lufs::Local',
    'VERSION_FROM'	=> '../Lufs.pm',
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Local.pm', # retrieve abstract from module
       AUTHOR     => 'root <root@intern>') : ()),
);
