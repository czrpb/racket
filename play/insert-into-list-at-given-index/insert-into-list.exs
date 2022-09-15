defmodule InsertIntoList do
  def insert_after_index(list, new_items) do
    new_items_hash = Enum.into(new_items, %{}, fn {n, i} -> {i, n} end)
    0..(length(list) + map_size(new_items_hash) - 1)
    |> Enum.reduce([[], list], fn
       i, [acc, [l|rest]=list] ->
        if new_items_hash[i] do
          [[new_items_hash[i]|acc], list]
        else
          [[l|acc], rest]
        end
    end)
    |> hd
    |> Enum.reverse()
  end

  def insert_before_index(list, new_items) do
    new_items_hash = Enum.into(new_items, %{}, fn {n, i} -> {i, n} end)
    list
    |> Enum.with_index()
    |> Enum.flat_map(fn {l, i} ->
       (if new_items_hash[i], do: [new_items_hash[i], l], else: [l])
    end)
  end
end

input1 = [["A", "C", "E"], [{"B", 1}, {"D", 3}]]
input2 = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [{"A", 1}, {"B", 3}, {"C", 6}]]

IO.inspect(input1)
Kernel.apply(InsertIntoList, :insert_after_index, input1)
|> IO.inspect(label: "   -->\t")

IO.inspect(input2)
Kernel.apply(InsertIntoList, :insert_after_index, input2)
|> IO.inspect(label: "   -->\t")

IO.puts("")

IO.inspect(input1)
Kernel.apply(InsertIntoList, :insert_before_index, input1)
|> IO.inspect(label: "   -->\t")

IO.inspect(input2)
Kernel.apply(InsertIntoList, :insert_before_index, input2)
|> IO.inspect(label: "   -->\t")
