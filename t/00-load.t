#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'MooX::Role::PubSub' ) || print "Bail out!\n";
}

diag( "Testing MooX::Role::PubSub $MooX::Role::PubSub::VERSION, Perl $], $^X" );
