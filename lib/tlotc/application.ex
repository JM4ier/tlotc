defmodule TLotC.Application do
    def start(_type, _args) do
        IO.puts "Starting TLotC..."
        children = [
            TLotC.Consumer,
            Nosedrum.Storage.ETS,
            #TLotC.Services.RoleManager,
        ]
        options = [strategy: :one_for_one, name: TLotC.Supervisor]
        Supervisor.start_link(children, options)
    end
end
