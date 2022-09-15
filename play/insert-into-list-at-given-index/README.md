# Insert items into a List Given an Index

The inspiration of this problem came from a post on the Elixir forum:

https://elixirforum.com/t/enum-over-list-and-insert-items-from-another-list-at-certain-indexes/50263

Say we have a list. We are given a 2nd list of 2-element tuples where the 1st element
is a value and the 2nd element is an index where the new value should be placed.

But .. there are 2 interpretations of what that index means, meaning where the
new value should be in the resultant list.

## Indexes are Relative to the Given List

One interpretation is that the index is the index in the original at which the new
value should be inserted.

Example 1:

> List of values: `("A" "C" "E")`
> List of tuples: `(("B" 1) ("D" 3))`
> 
> Expected output: `(("B" 1) ("D" 3))`

Example 2:

> List of values: `(1 2 3 4 5 6 7 8 9 10)`
> List of tuples: `(("A" 1) ("B" 3) ("C" 6))`
> 
> Expected output: `(1 "A" 2 3 "B" 4 5 6 "C" 7 8 9 10)`

## Indexes are Relative to the Resultant List

Another interpretation is that the index is the index at which the new value should
be found in the resultant list.

Example 1:

> List of values: `("A" "C" "E")`
> List of tuples: `(("B" 1) ("D" 3))`
> 
> Expected output: `("A" "B" "C" "D" "E")`

Example 2:

> List of values: `(1 2 3 4 5 6 7 8 9 10)`
> List of tuples: `(("A" 1) ("B" 3) ("C" 6))`
> 
> Expected output: `(1 "A" 2 "B" 3 4 "C" 5 6 7 8 9 10)`
