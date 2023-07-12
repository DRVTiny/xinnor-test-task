package R::CLI::SlotsShort;
use feature 'switch';
use 5.32.1;    # CentOS 7 from previous century already includes Perl 5.16.1!
use strict;
use warnings;
no warnings 'experimental';
use Scalar::Util qw(looks_like_number);
use List::Util qw(all);

use Exporter;
our @ISA    = qw/Exporter/;
our @EXPORT = qw/slots_short slots_unshort/;

use constant TRUE => 1;
use constant {
    FALSE            => !TRUE,
    OPTION_DELIMITER => ',',
};

#------------------------------
# Public API
#------------------------------
sub slots_unshort($) {
    my @data = split OPTION_DELIMITER, $_[0];

    return map {
        my $el = $_;
        given ($el) {
            $1 + 0 when /^\s*(\d+)\s*$/;
            get_element($1, $2) when /^\s*(\d+)-(\d+)\s*$/;
            default {return}
        }
    } @data;
}

sub slots_short(@) {
    my @array  = @_;
    my $result = '';

    return FALSE unless every_el_is_num(@array);

    my @short_arr       = (0 .. $#array);
    my $short_arr_index = 0;
    for (my $index = 0; $index <= $#array; $index++) {
        if (my $uindex = is_stackable($index, @array)) {
            @short_arr[$short_arr_index++] = [$array[$index], $array[$uindex]];
            $index = $uindex;
        } else {
            @short_arr[$short_arr_index++] = $array[$index];
        }
    }

    return join(
        ',' => map ref() ? join('-', @{$_}) : $_,
        @short_arr[0 .. ($short_arr_index - 1)]
    );
}

#------------------------------
# Helper functions
#------------------------------

sub get_element ($$) {
    my ($lbound, $rbound) = @_;

    ($lbound, $rbound) = ($rbound, $lbound) if $rbound < $lbound;
    return ($lbound .. $rbound);
}

sub every_el_is_num (@) {
    all {looks_like_number($_) and $_ > 0} @_;
}

sub is_stackable ($@) {
    my ($index, @array) = @_;
    # it doesn't make sense to stack maximum 2 elements of array
    return FALSE if $index < 0 or ($index + 2) >= scalar @array;

    my $els_cnt = 0;
    my $cur_el  = $array[$index];
    while ($index < $#array) {
        if ($cur_el + 1 == (my $nxt_el = $array[$index + 1])) {
            $cur_el = $nxt_el;
            $index   += 1;
            $els_cnt += 1;
        } else {
            last;
        }
    }

    return $els_cnt >= 2 ? $index : FALSE;
}

1;
__END__
