defmodule SeemaTree do
  def new(), do: nil

  def add(nil, key, value), do: {:node, key, value, nil, nil}
  def add({:node, key, _, left, right}, key, value), do: {:node, key, value, left, right}
  def add({:node, k, v, left, right}, key, value) when key < k, do: {:node, k, v, add(left, key, value), right}
  def add({:node, k, v, left, right}, key, value) when key > k, do: {:node, k, v, left, add(right, key, value)}

  def lookup(nil, _key), do: nil
  def lookup({:node, key, value, _, _}, key), do: {key, value}
  def lookup({:node, k, _, left, _}, key) when k < key, do: lookup(left, key)
  def lookup({:node, k, _, _, right}, key) when k > key, do: lookup(right, key)

  def remove(nil, _), do: nil
  def remove({:node, key, _, left, nil}, key), do: left
  def remove({:node, key, _, nil, right}, key), do: right
  def remove({:node, key, _, left, right}, key) do
    {key, value, rest} = leftmost(right)
    {:node, key, value, left, rest}
  end
  def remove({:node, k, v, left, right}, key) when k < key, do: {:node, k, v, remove(left, key), right}
  def remove({:node, k, v, left, right}, key) when k > key, do: {:node, k, v, left, remove(right, key)}

  def leftmost({:node, key, value, nil, _rest}), do: {key, value, nil}
  def leftmost({:node, k, v, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end
end
