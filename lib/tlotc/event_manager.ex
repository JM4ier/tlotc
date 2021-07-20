defmodule TLotC.EventManager do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def register(kind, mod, fun) do
    Agent.update(__MODULE__, &[{kind, mod, fun} | &1])
  end

  def dispatch(kind, args) do
    args =
      if is_tuple(args) do
        Tuple.to_list(args)
      else
        [args]
      end

    Agent.get(__MODULE__, & &1)
    |> Enum.each(fn {typ, mod, fun} ->
      if typ == kind do
        apply(mod, fun, args)
      end
    end)
  end
end
