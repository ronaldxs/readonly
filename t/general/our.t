#!perl -I../../lib

# Test Readonly package variables

use strict;
use Test::More tests => 19;

# Find the module (1 test)
BEGIN {use_ok('Readonly'); }

package P;

use Readonly;
use Test::More;

Readonly my $lex_s => 46;
Readonly our $pack_s => 47;
Readonly::Scalar our $exp_pack_s => 48;
Readonly my @lex_a => qw(abc def);
Readonly our @pack_a => qw(ghi jkl);
Readonly::Array our @exp_pack_a => qw(mno pqr);
Readonly my %lex_h => (k1 => "v1");
Readonly our %pack_h => (k2 => "v2");
Readonly::Hash our %exp_pack_h => (k3 => "v3");

is $lex_s, 46, 'local access to lex scalar';
is $pack_s, 47, 'local access to package scalar';
is $exp_pack_s, 48, 'local access to package scalar';
is_deeply \@lex_a, [qw(abc def)], 'local access to lex array';
is_deeply \@pack_a, [qw(ghi jkl)], 'local access to package array';
is_deeply \@exp_pack_a, [qw(mno pqr)], 'local access to package array';
is_deeply \%lex_h, { k1 => "v1" }, 'local access to lex array';
is_deeply \%pack_h, { k2 => "v2" }, 'local access to package array';
is_deeply \%exp_pack_h, { k3 => "v3" }, 'local access to package array';

1;

package main;
no warnings 'once';

ok((not defined $P::lex_s), 'lex scalar not visible outside package');
is($P::pack_s, 47, 'good access to package scalar');
is($P::exp_pack_s, 48, 'good access to Readonly::Scalar package scalar');
is scalar(@P::lex_a), 0, 'lex array not defined outside package';
is_deeply \@P::pack_a, [qw(ghi jkl)], 'good value of package array';
is_deeply \@P::exp_pack_a, [qw(mno pqr)],
    'good value of Readonly::Array package array';
is scalar(%P::lex_h), 0, 'lex hash not defined outside package';
is_deeply \%P::pack_h, { k2 => "v2" }, 'good value of package hash';
is_deeply \%P::exp_pack_h, { k3 => "v3" },
    'good value of Readonly::Hash package hash';

SKIP: {
    #	skip 'Readonly $@% syntax is for perl 5.8 or later', 9 unless $] >= 5.008;
    #	doing this skip properly requires creating package variables
    #	with eval which I can't seem to get just now
   1 
};
