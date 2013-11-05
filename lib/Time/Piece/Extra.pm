package Time::Piece::Extra;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use Time::Piece;
use Time::Seconds ();
use Time::Local ();

sub import {
    my ($package) = @_;

    if (grep { $_ eq ':include' } @_) {
        require Time::Piece::Extra::Include;
    }
}

sub from_ymd {
    my ($class, $y, $m, $d) = @_;
    return $class->from_ymdhms($y, $m, $d, 0, 0, 0);
}

sub from_ymd_gmt {
    my ($class, $y, $m, $d) = @_;
    return $class->from_ymdhms_gmt($y, $m, $d, 0, 0, 0);
}

sub from_ymdhms {
    my ($class, $y, $m, $d, $H, $M, $S) = @_;
    $m ||= 1;
    $d ||= 1;
    $H ||= 0;
    $M ||= 0;
    $S ||= 0;

    return localtime( Time::Local::timelocal($S, $M, $H, $d, $m-1, $y) );
}

sub from_ymdhms_gmt {
    my ($class, $y, $m, $d, $H, $M, $S) = @_;
    $m ||= 1;
    $d ||= 1;
    $H ||= 0;
    $M ||= 0;
    $S ||= 0;

    return gmtime( Time::Local::timegm($S, $M, $H, $d, $m-1, $y) );
}

sub now {
    my ($class, %args) = @_;
    my $is_gmt = $args{utc} || $args{gmt};
    return $is_gmt ? scalar gmtime(time) : scalar localtime(time);
}

sub today {
    my ($class, %args) = @_;
    return $class->date_of(scalar $class->now(%args));
}

sub date_of {
    my ($class, $tp) = @_;
    my $is_local = $tp->[Time::Piece::c_islocal];
    if ($is_local) {
        return $class->from_ymd($tp->year, $tp->mon, $tp->mday);
    } else {
        return $class->from_ymd_gmt($tp->year, $tp->mon, $tp->mday);
    }
}

sub add_days {
    my ($class, $tp, $days) = @_;
    return $tp + Time::Seconds::ONE_DAY() * $days;
}

sub start_of_month {
    my ($class, $tp) = @_;
    my $is_local = $tp->[Time::Piece::c_islocal];
    if ($is_local) {
        return $class->from_ymd($tp->year, $tp->mon, 1);
    } else {
        return $class->from_ymd_gmt($tp->year, $tp->mon, 1);
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Piece::Extra - Lost pieces of Time::Piece

=head1 SYNOPSIS

    use Time::Piece::Extra;

=head1 DESCRIPTION

Time::Piece::Extra is ...

=head1 LICENSE

Copyright (C) ITO Nobuaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ITO Nobuaki E<lt>dayflower@cpan.orgE<gt>

=cut
