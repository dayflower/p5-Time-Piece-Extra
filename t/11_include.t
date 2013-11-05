use strict;
use warnings;
use Test::More;
use Time::Piece::Extra ':include';

my $is_pseudo_fork;
if (defined &Win32::GetCurrentProcessId
    ? $$ != Win32::GetCurrentProcessId() : $^O eq 'MSWin32' && $$ < 0) {
    $is_pseudo_fork = 1;
}

local $ENV{TZ} = $ENV{TZ};
if (! $is_pseudo_fork) {
    $ENV{TZ} = 'EST5';
    Time::Piece::_tzset();
}

subtest 'as_date for local time' => sub {
    my $t = Time::Piece::Extra->from_ymdhms(2008, 3, 23, 1, 23, 45);

    my $d = $t->as_date;

    is $d->year, 2008;
    is $d->mon,     3;
    is $d->mday,   23;
    is $d->hour,    0;
    is $d->min,     0;
    is $d->sec,     0;

    SKIP: {
        skip "cannot change TZ for pseudo-fork env." if $is_pseudo_fork;

        is $t->tzoffset, -18000;

        is $t->strftime('%Z'), 'EST';
    };

    is $d->[Time::Piece::c_islocal], 1;
};

subtest 'as_date for gmt' => sub {
    my $t = Time::Piece::Extra->from_ymdhms_gmt(2008, 3, 23, 1, 23, 45);

    my $d = $t->as_date;

    is $d->year, 2008;
    is $d->mon,     3;
    is $d->mday,   23;
    is $d->hour,    0;
    is $d->min,     0;
    is $d->sec,     0;

    is $d->tzoffset, 0;

    TODO: {
        local $TODO = "strftime('%Z') for gmtime returns local timezone";
        is $d->strftime('%Z'), 'UTC';
    };

    is $d->[Time::Piece::c_islocal], 0;
};

subtest 'add_days' => sub {
    my $t = Time::Piece::Extra->from_ymdhms(2008, 3, 23, 1, 23, 45);

    my $d = $t->add_days(123);

    is $d->year, 2008;
    is $d->mon,     7;
    is $d->mday,   24;
    is $d->hour,    1;
    is $d->min,    23;
    is $d->sec,    45;

    SKIP: {
        skip "cannot change TZ for pseudo-fork env." if $is_pseudo_fork;

        is $t->tzoffset, -18000;

        is $t->strftime('%Z'), 'EST';
    };

    is $d->[Time::Piece::c_islocal], 1;
};

subtest 'start_of_month' => sub {
    my $t = Time::Piece::Extra->from_ymdhms(2008, 3, 23, 1, 23, 45);

    my $d = $t->start_of_month;

    is $d->year, 2008;
    is $d->mon,     3;
    is $d->mday,    1;
    is $d->hour,    0;
    is $d->min,     0;
    is $d->sec,     0;

    SKIP: {
        skip "cannot change TZ for pseudo-fork env." if $is_pseudo_fork;

        is $t->tzoffset, -18000;

        is $t->strftime('%Z'), 'EST';
    };

    is $d->[Time::Piece::c_islocal], 1;
};

subtest 'start_of_month for gmt' => sub {
    my $t = Time::Piece::Extra->from_ymdhms_gmt(2008, 3, 23, 1, 23, 45);

    my $d = $t->start_of_month;

    is $d->year, 2008;
    is $d->mon,     3;
    is $d->mday,    1;
    is $d->hour,    0;
    is $d->min,     0;
    is $d->sec,     0;

    is $d->tzoffset, 0;

    TODO: {
        local $TODO = "strftime('%Z') for gmtime returns local timezone";
        is $d->strftime('%Z'), 'UTC';
    };

    is $d->[Time::Piece::c_islocal], 0;
};

done_testing;
