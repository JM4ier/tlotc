defmodule TLotC.Cogs.Emote do
  alias Nostrum.Api
  alias TLotC.Helpers
  alias TLotC.Predicates
  alias TLotC.Emojis

  @behaviour Nosedrum.Command

  @impl true
  def predicates, do: [&Predicates.owner_only/1]

  @impl true
  def usage,
    do: [
      "add <:kekw:858260643764109332>"
    ]

  @impl true
  def description,
    do: """
        This command adds emotes to the server.
    """

  @impl true
  def command(msg, ["add" | rest]) do
    ref_emotes =
      if ref = msg.message_reference,
        do: Api.get_channel_message!(ref.channel_id, ref.message_id).content,
        else: ""

    emotes = msg.content <> ref_emotes
    Emojis.add_new_emojis(emotes)
  end

  def command(msg, _) do
    Api.create_message(msg.channel_id, "No action specified.")
  end
end
