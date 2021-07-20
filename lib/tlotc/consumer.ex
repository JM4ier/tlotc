defmodule TLotC.Consumer do
  alias TLotC.Consumer.{
    Ready,
    MessageReactionAdd,
    MessageCreate
  }

  alias TLotC.EventManager

  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({event, data, _ws_state}) do
    EventManager.dispatch(event, data)
    he_old({event, data, _ws_state})
  end

  def he_old({:READY, data, _ws_state}) do
    Ready.handle(data)
  end

  def he_old({:MESSAGE_REACTION_ADD, reaction, _ws_state}) do
    MessageReactionAdd.handle(reaction)
  end

  def he_old({:MESSAGE_CREATE, msg, _ws_state}) do
    spawn(fn -> MessageCreate.handle(msg) end)
  end

  # unhandled events
  def he_old(_event) do
  end
end
