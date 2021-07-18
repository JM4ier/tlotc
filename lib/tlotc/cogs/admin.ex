defmodule TLotC.Cogs.Admin do
  alias Nostrum.Api

  @behaviour Nosedrum.Command

  @impl true
  def predicates, do: [&TLotC.Predicates.owner_only/1]

  @impl true
  def usage, do: ["update"]

  @impl true
  def description, do: "Bot Management"

  @impl true
  def command(_msg, ["update"]) do
    {_out, 0} = System.cmd("git", ["pull"])
    IEx.Helpers.recompile()
    TLotC.Consumer.Ready.load_commands()
  end

  def command(_msg, _args) do
  end
end
