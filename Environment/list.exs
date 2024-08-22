defmodule SeemaList do  # Renaming List module to MyList

  # Creating a new list
  def new() do [] end

  # Adding to a list, each node in the list has a (key, value)
  def add([], key, value) do [{key, value}] end
  def add([{key, _} | map], key, value) do [{key, value} | map] end
  def add([first | map], key, value) do [first | add(map, key, value)] end

  # Look-up in the list
  def lookup([], _key), do: nil
  def lookup([{key, value} | _], key), do: value
  def lookup([_ | map], key), do: lookup(map, key)

  # Removing from the list
  def remove([], _key), do: []
  def remove([{key, _} | map], key), do: map
  def remove([first | map], key), do: [first | remove(map, key)]

end
