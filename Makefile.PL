
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'pure Perl implementation of MST parser',
  'AUTHOR' => 'Rudolf rosa <rosa@ufal.mff.cuni.cz>',
  'BUILD_REQUIRES' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'FindBin' => '0',
    'Test::More' => '0',
    'utf8' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Treex-Parser-MSTperl',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Treex::Parser::MSTperl',
  'PREREQ_PM' => {
    'Carp' => '0',
    'Data::Dumper' => '0',
    'Graph' => '0',
    'Graph::ChuLiuEdmonds' => '0',
    'Graph::Directed' => '0',
    'Moose' => '0',
    'YAML::Tiny' => '0',
    'autodie' => '0'
  },
  'VERSION' => '0.07298',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



