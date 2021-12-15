defmodule TLotC.Services.Cryo do
  alias Nostrum.Api
  alias TLotC.EventManager
  alias TLotC.Helpers

  use Agent

  def start_link(_opts) do
    EventManager.register(:MESSAGE_CREATE, __MODULE__, :handle)
    Agent.start_link(fn -> {} end, name: __MODULE__)
  end

  def handle(msg) do
    if msg.channel_id == 913023291655090196 do
      Api.add_guild_member_role(Helpers.guild(), msg.author.id, Helpers.online_role())
      :timer.sleep(1000)
      Api.remove_guild_member_role(Helpers.guild(), msg.author.id, Helpers.cryo_role())
      :timer.sleep(1000)
      Api.delete_message(msg)
    end
  end

  def send_to_sleep() do
    Api.list_guild_members!(Helpers.guild(), limit: 1000)
    |> Enum.filter(fn m -> Enum.member?(m.roles, Helpers.online_role()) end)
    |> IO.inspect
    |> Enum.each(fn m ->
      id = m.user.id
      Api.add_guild_member_role(Helpers.guild(), id, Helpers.cryo_role())
      :timer.sleep(1000)
      Api.remove_guild_member_role(Helpers.guild(), id, Helpers.online_role())
      :timer.sleep(1000)
    end)
  end

end
