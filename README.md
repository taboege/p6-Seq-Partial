# NAME

Seq::Partial - Iterate a Seq partially

## SYNOPSIS

``` perl6
use Seq::Partial;

my $seq := 1, 1, * + * ... *;
say $seq.partial.first(* %% 11);  #= 55
say $seq.first;                   #= 89

# Without .partial above, the second use of $seq
# would throw an X::Seq::Consumed exception.
```

## DESCRIPTION

Seq::Partial allows the partial iteration of a Seq.

## WHY

Imagine the following situation: you want to process a line-oriented text file, first there is a header, then a body, and the header determines what to do with the body. Naturally header parsing and the multitude of body parsers are separated. You use a Seq to not have to store the entire file in memory --- but! after reading header lines from the Seq, in your body parser you get

    The iterator of this Seq is already in use/consumed by another Seq
    (you might solve this by adding .cache on usages of the Seq, or by
    assigning the Seq into an array)

This is because the header parser took the Seq's iterator and the Seq is useless now.

Seq::Partial adds a method `.partial` to the Seq class which avoids precisely that. It gives you the iterator without marking the Seq as consumed, so that you can continue iterating over it elsewhere. You may also see this as stealing a Seq's iterator, so be careful about data races!

This module extends the built-in Seq class by the following methods.

## method partial

Returns a new Seq which shares the current one's iterator.

This allows you to iterate a Seq partially without it being marked as consumed. It also means that both sequences race for the same source of values, so be wary of passing both Seqs around to other code.

AUTHOR
======

Tobias Boege <tobs@taboege.de>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Tobias Boege

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
