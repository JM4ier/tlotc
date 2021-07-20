defmodule TLotC.Services.AutoReactionAdd do
  alias Nostrum.Api
  alias TLotC.EventManager

  use Agent

  def start_link(_opts) do
    EventManager.register(:MESSAGE_CREATE, __MODULE__, :handle)
    Agent.start_link(fn -> {} end, name: __MODULE__)
  end

  def handle(msg) do
    if msg.channel_id == 867101188205707274 do
      Api.create_reaction!(msg.channel_id, msg.id, ":this:858260896597803019")
      :timer.sleep(2000)
      Api.create_reaction!(msg.channel_id, msg.id, ":that:858260886799777792")
    end
  end
end
