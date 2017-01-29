#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WebPush::OneSignal' ) || print "Bail out!\n";
}

diag( "Testing WebPush::OneSignal $WebPush::OneSignal::VERSION, Perl $], $^X" );
