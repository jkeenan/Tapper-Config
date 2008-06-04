#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Artemis::Config' );
}

diag( "Testing Artemis::Config $Artemis::Config::VERSION, Perl $], $^X" );
