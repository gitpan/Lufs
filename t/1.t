# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('Lufs') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $l = Lufs->new;
pass('object creation');
ok($l->_init("Lufs.Local", 'arghhh', '/'),'_init');
$l->{fs}->TRACE('test message 1');
pass('trace messages');
