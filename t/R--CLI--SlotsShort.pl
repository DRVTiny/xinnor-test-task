use 5.16.1;
use File::Spec;
use FindBin;
use lib File::Spec->catfile($FindBin::RealBin, '..', 'lib');
use Test::More;
no warnings 'experimental';
BEGIN {use_ok('R::CLI::SlotsShort', qw(slots_short slots_unshort))}

my @arr_packable   = (1, 2, 3, 5, 17, 18, 273, 391, 507, 508, 509, 510, 512);
my @arr_unpackable = (1, 2, 4, 6, 7,  9,  11,  12,  14);

ok([slots_unshort slots_short @arr_packable] ~~ \@arr_packable, 'we ve got the same array after unpacking');
is(slots_short(@arr_unpackable), join(',' => @arr_unpackable), 'we dont try to pack short (2 els long) monothonic sequences');

done_testing();
