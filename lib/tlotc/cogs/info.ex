defmodule TLotC.Cogs.Info do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias TLotC.Helpers

  @impl true
  def predicates, do: []

  @impl true
  def usage,
    do: [
      ""
    ]

  @impl true
  def description, do: "Displays info of this bot"

  @impl true
  def command(msg, _args) do
    embed = %Embed{
      title: "Info",
      description: """
      I am TLotC, a bot written in Elixir.
      You can find out what I can do with `.help`.
      <@!#{Helpers.owner()}> is my owner, and you can find the source of me [here](https://github.com/JM4ier/tlotc).
      """
    }

    Api.create_message!(msg.channel_id, embed: embed)
  end
end
