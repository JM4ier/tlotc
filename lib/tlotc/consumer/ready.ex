defmodule TLotC.Consumer.Ready do
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias TLotC.Cogs
  alias Nostrum.Api

  @commands %{
    "help" => Cogs.Help,
    "color" => Cogs.Color,
    "info" => Cogs.Info,
    "emote" => Cogs.Emote,
    "escape" => Cogs.Escape,
    "admin" => Cogs.Admin,
    "blind" => Cogs.Blind,
    "track" => Cogs.Track
  }

  @spec handle(map()) :: :ok
  def handle(_data) do
    :ok = load_commands()
    :ok = Api.update_status(:online, "birds outside", 3)
  end

  def load_commands do
    @commands
    |> Enum.each(fn {name, cog} ->
      CommandStorage.remove_command([name])
      CommandStorage.add_command([name], cog)
    end)
  end
end
