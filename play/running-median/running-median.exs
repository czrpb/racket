defmodule RunningMedian do
  def median(list) do
    d = div(length(list), 2)
    r = rem(length(list), 2)

    if r==0 do
      [a,b|_] = Enum.drop(list, d-1)
      (b+a)/2
    else
      Enum.at(list, d)
    end
  end
  def rm([h|t]) do
    {_, medians} = Enum.reduce(t, {[h], [h]}, fn
                     next_num, {nums, rms} ->
                       nums = Enum.sort([next_num | nums])
                       {nums, [median(nums)|rms]}
                   end)
    Enum.reverse(medians)
  end
end

System.argv()
|> Enum.map(&String.to_integer/1)
|> RunningMedian.rm()
|> IO.inspect(label: "Running medians")
