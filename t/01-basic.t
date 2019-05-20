use Test;
use Seq::Partial;

plan 5;

my $seq;

$seq := 1, 1, * + * ... *;
is $seq.first(* %% 11), 55, 'search for Fibonacci number';
throws-like { $seq.first }, X::Seq::Consumed, 'dies of being consumed';

$seq := 1, 1, * + * ... *;
is $seq.partial.first(* %% 11), 55, 'partial search for Fibonacci number';
is $seq.skip.first, 144, 'continues where left off';

$seq := 1, 2, 4 ... *;
sink $seq.partial.first(* > 64);
is $seq.partial.first xx 3, [256, 512, 1024], 'continues often';
