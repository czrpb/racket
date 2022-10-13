# Find Running Median

Find the running medians of a list.

## Example

```text
[1, 2, 3, 4, 5] -> [1, 1.5, 2, 2.5, 3]
```

## Note 1: Using `quickselect`

In racket the builtin library called `math/statistics` has a `median` function, which:

https://docs.racket-lang.org/math/stats.html#%28def._%28%28lib._math%2Fstatistics..rkt%29._quantile%29%29

> For unweighted samples, quantile uses the quickselect algorithm to find
> the element that would be at index `(ceiling (- (* p n) 1))` if `xs` were
> sorted, where `n` is the length of `xs`.

Which means we cant get the above list and instead get:

```text
[1, 2, 3, 4, 5] -> [1, 1, 2, 2, 3]
```
