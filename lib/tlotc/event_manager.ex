defmodule TLotC.EventManager do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def register(kind, callback) do
    Agent.update(__MODULE__, &[{kind, callback} | &1])
  end

  def dispatch(kind, args) do
    args =
      if is_tuple(args) do
        Tuple.to_list(args)
      else
        [args]
      end

    Agent.get(__MODULE__, & &1)
    |> Enum.each(fn {typ, callback} ->
      if typ == kind do
        apply(callback, args)
      end
    end)
  end
end
