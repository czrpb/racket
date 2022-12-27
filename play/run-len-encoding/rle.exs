defmodule RLE do
  def rle(l) do
    rle_(l, 1, [])
  end

  def rle_([a], c, acc) do
    Enum.reverse([{a, c} | acc])
  end

  def rle_([a, a | t], c, acc) do
    rle_([a | t], c + 1, acc)
  end

  def rle_([a | t], c, acc) do
    rle_(t, 1, [{a, c} | acc])
  end
end

l = [1, 2, 2, 2, 3, 4, 4, 5, 6, 6, 6, 6]

RLE.rle(l)
|> IO.inspect()
