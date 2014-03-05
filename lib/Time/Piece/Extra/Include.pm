package Time::Piece::Extra::Include;
use 5.008005;
use strict;
use warnings;

use Time::Piece;

package Time::Piece;

use Time::Piece::Extra;

sub from_ymd {
    shift;
    return Time::Piece::Extra->from_ymd(@_);
}

sub from_ymd_gmt {
    shift;
    return Time::Piece::Extra->from_ymd_gmt(@_);
}

sub from_ymdhms {
    shift;
    return Time::Piece::Extra->from_ymdhms(@_);
}

sub from_ymdhms_gmt {
    shift;
    return Time::Piece::Extra->from_ymdhms_gmt(@_);
}

sub now {
    shift;
    return Time::Piece::Extra->now(@_);
}

sub now_gmt {
    shift;
    return Time::Piece::Extra->now_gmt(@_);
}

sub today {
    shift;
    return Time::Piece::Extra->today(@_);
}

sub today_gmt {
    shift;
    return Time::Piece::Extra->today_gmt(@_);
}

sub as_date {
    my $self = shift;
    return Time::Piece::Extra->date_of($self, @_);
}

sub add_days {
    my $self = shift;
    return Time::Piece::Extra->add_days($self, @_);
}

sub start_of_month {
    my $self = shift;
    return Time::Piece::Extra->start_of_month($self, @_);
}

sub strptime_local {
    my $self = shift;
    return Time::Piece::Extra->strptime_local($self, @_);
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Piece::Extra::Include - Mix Time::Piece::Extra functions into Time::Piece

=head1 SYNOPSIS

    use Time::Piece::Extra ':include';

=head1 DESCRIPTION

Time::Piece::Extra::Include is ...

=head1 LICENSE

Copyright (C) ITO Nobuaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ITO Nobuaki E<lt>dayflower@cpan.orgE<gt>

=cut
