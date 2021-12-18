defmodule TLotC.Application do
  def start(_type, _args) do
    IO.puts("Starting TLotC...")

    children = [
      TLotC.Consumer,
      TLotC.EventManager,
      Nosedrum.Storage.ETS,
      TLotC.Services.AutoReactionAdd,
      TLotC.Services.Tracker,
      TLotC.Services.Cryo
    ]

    options = [strategy: :one_for_one, name: TLotC.Supervisor]
    Supervisor.start_link(children, options)
  end
end
