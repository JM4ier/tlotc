defmodule TLotC.Services.AutoReactionAdd do
  alias Nostrum.Api
  alias TLotC.EventManager

  use Agent

  def start_link(_opts) do
    EventManager.register(:MESSAGE_CREATE, &on_message_create/1)
    Agent.start_link(fn -> {} end, name: __MODULE__)
  end

  def on_message_create(msg) do
    IO.puts("#{msg.content}")
  end
end
