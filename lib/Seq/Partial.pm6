=begin pod

=head1 NAME

Seq::Partial - Iterate a Seq partially

=head1 SYNOPSIS

=begin code

use Seq::Partial;

my $seq := 1, 1, * + * ... *;
say $seq.partial.first(* %% 11);  #= 55
say $seq.first;                   #= 89

# Without .partial above, the second use of $seq
# would throw an X::Seq::Consumed exception.

=end code

=head1 DESCRIPTION

Seq::Partial allows the partial iteration of a Seq.

=head2 WHY

Imagine the following situation: you want to process a line-oriented
text file, first there is a header, then a body, and the header
determines what to do with the body. Naturally header parsing and the
multitude of body parsers are separated. You use a Seq to not have
to store the entire file in memory --- but! after reading header
lines from the Seq, in your body parser you get

    The iterator of this Seq is already in use/consumed by another Seq
    (you might solve this by adding .cache on usages of the Seq, or by
    assigning the Seq into an array)

This is because the header parser took the Seq's iterator and the
Seq is useless now.

Seq::Partial adds a method C<.partial> to the Seq class which avoids
precisely that. It gives you the iterator without marking the Seq as
consumed, so that you can continue iterating over it elsewhere.
You may also see this as stealing a Seq's iterator, so be careful
about data races!

=end pod

unit class Seq::Partial:ver<0.1.0>:auth<github:taboege>:api<0>;

use MONKEY-TYPING;

=begin pod

This module extends the built-in Seq class by the following methods.

=end pod

augment class Seq {
    =begin pod

    =head2 method partial

        multi method partial

    Returns a new Seq which shares the current one's iterator.

    This allows you to iterate a Seq partially without it being marked
    as consumed. It also means that both sequences race for the same source
    of values, so be wary of passing both Seqs around to other code.

    =end pod

    multi method partial {
        Seq.new: $!iter
    }
}

=begin pod

=head1 AUTHOR

Tobias Boege <tobs@taboege.de>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Tobias Boege

This library is free software; you can redistribute it
and/or modify it under the Artistic License 2.0.

=end pod
