# LZ77 Compression

Fundamentally, LZ77/78 compression works by:

> LZ77 algorithms achieve compression by replacing repeated occurrences of
> data with references to a single copy of that data existing earlier in the
> uncompressed data stream.
> 
>   https://en.wikipedia.org/wiki/LZ77_and_LZ78

Here will by my implementation of this algorithm in Racket/Scheme. The goal is
more to learn Racket/Scheme than the algorithm. The choice of algorithm is that
it is something non-trivial vs the many trivial problems available online.

(This said, things like Advent Of Code and Exercism are much better than other
sites like l33tcode so ...)

## Nano LZ77 

In the 1st implementation, I am constraining the solution by:

1. Words are random characters of length 2 to 6 of just a-z.
1. No puncuation, so not really sentences or paragraphs.
1. The text to be compressed is limited to a total of 255 bytes,
   including the spaces between "words".

The *reference* is thus just 1 byte as an *offset* from the beginning of the text.

### Encoding

Only expand this AFTER you have worked on your own algorithm.

<details><summary>The algorithm is:</summary>

<pre>
For each word:
  If we have seen the word before write its offset as a byte into the output stream,
  otherwise write the word to the output stream and save the word in our current
  dictionary with the current offset.
</pre>

Implementation here: <a href="/play/lz77/nano/lz77.rkt">nano/lz77.rkt</a>

</details>

## Micro LZ77

In this implementation, constraints are eased:

1. Words are still random letters of a-z, and now 1 to 8 in length.
1. Simulated sentences of length 4 - 10 words, and a `,` every now and then.
1. No text length limit.

Thus, the *reference* is still 1byte and is not an offset but distance *backwards*
in the stream, thus a *back reference*.

### Encoding

