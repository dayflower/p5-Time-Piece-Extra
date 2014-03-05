use strict;
use warnings;
use Test::More;
use Time::Piece::Extra;

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

subtest 'from_ymd' => sub {
    my $t = Time::Piece::Extra->from_ymd(2008, 3, 23);

    is $t->year, 2008;
    is $t->mon,     3;
    is $t->mday,   23;
    is $t->hour,    0;
    is $t->min,     0;
    is $t->sec,     0;

    SKIP: {
        skip "cannot change TZ for pseudo-fork env." if $is_pseudo_fork;

        is $t->tzoffset, -18000;

        is $t->strftime('%Z'), 'EST';
    };

    is $t->[Time::Piece::c_islocal], 1;
};

subtest 'from_ymd_gmt' => sub {
    my $t = Time::Piece::Extra->from_ymd_gmt(2008, 3, 23);

    is $t->year, 2008;
    is $t->mon,     3;
    is $t->mday,   23;
    is $t->hour,    0;
    is $t->min,     0;
    is $t->sec,     0;

    is $t->tzoffset, 0;

    TODO: {
        local $TODO = "strftime('%Z') for gmtime returns local timezone";
        is $t->strftime('%Z'), 'UTC';
    };

    is $t->[Time::Piece::c_islocal], 0;
};

subtest 'from_ymdhms' => sub {
    my $t = Time::Piece::Extra->from_ymdhms(2008, 3, 23, 1, 23, 45);

    is $t->year, 2008;
    is $t->mon,     3;
    is $t->mday,   23;
    is $t->hour,    1;
    is $t->min,    23;
    is $t->sec,    45;

    SKIP: {
        skip "cannot change TZ for pseudo-fork env." if $is_pseudo_fork;

        is $t->tzoffset, -18000;

        is $t->strftime('%Z'), 'EST';
    };

    is $t->[Time::Piece::c_islocal], 1;
};

subtest 'from_ymdhms_gmt' => sub {
    my $t = Time::Piece::Extra->from_ymdhms_gmt(2008, 3, 23, 1, 23, 45);

    is $t->year, 2008;
    is $t->mon,     3;
    is $t->mday,   23;
    is $t->hour,    1;
    is $t->min,    23;
    is $t->sec,    45;

    is $t->tzoffset, 0;

    TODO: {
        local $TODO = "strftime('%Z') for gmtime returns local timezone";
        is $t->strftime('%Z'), 'UTC';
    };

    is $t->[Time::Piece::c_islocal], 0;
};

# TODO: now
# TODO: now( gmt => 1 )
# TODO: today
# TODO: today( gmt => 1 )

subtest 'date_of for local time' => sub {
    my $t = Time::Piece::Extra->from_ymdhms(2008, 3, 23, 1, 23, 45);

    my $d = Time::Piece::Extra->date_of($t);

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

subtest 'date_of for gmt' => sub {
    my $t = Time::Piece::Extra->from_ymdhms_gmt(2008, 3, 23, 1, 23, 45);

    my $d = Time::Piece::Extra->date_of($t);

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

    my $d = Time::Piece::Extra->add_days($t, 123);

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

    my $d = Time::Piece::Extra->start_of_month($t);

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

    my $d = Time::Piece::Extra->start_of_month($t);

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

subtest 'strptime_local' => sub {
    my $t = Time::Piece::Extra->strptime_local('2008-03-23T01:23:45', '%Y-%m-%dT%H:%M:%S');

    is $t->year, 2008;
    is $t->mon,     3;
    is $t->mday,   23;
    is $t->hour,    1;
    is $t->min,    23;
    is $t->sec,    45;

    is $t->tzoffset, -18000;

    is $t->[Time::Piece::c_islocal], 1;
};

done_testing;
