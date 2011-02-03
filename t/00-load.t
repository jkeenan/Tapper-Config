#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Tapper::Config' );
}

diag( "Testing Tapper::Config $Tapper::Config::VERSION, Perl $], $^X" );
