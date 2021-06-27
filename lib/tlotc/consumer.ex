defmodule TLotC.Consumer do
  alias TLotC.Consumer.{
    Ready,
    MessageReactionAdd,
    MessageCreate
  }

  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
    Ready.handle(data)
  end

  def handle_event({:MESSAGE_REACTION_ADD, reaction, _ws_state}) do
    MessageReactionAdd.handle(reaction)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    spawn(fn -> MessageCreate.handle(msg) end)
  end

  # unhandled events
  def handle_event(_event) do
  end
end
