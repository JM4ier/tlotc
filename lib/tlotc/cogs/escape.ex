defmodule TLotC.Cogs.Escape do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias TLotC.Helpers

  @behaviour Nosedrum.Command

  @impl true
  def predicates, do: []

  @impl true
  def usage,
    do: [""]

  @impl true
  def description,
    do: """
        This command escapes everything that can be pinged or mentioned.
        This can be useful for copying large amounts of emotes out of discord.
    """

  @impl true
  def command(msg, args) do
    escaped =
      args
      |> Enum.join(" ")
      |> String.replace("<", "\\<")
      |> String.replace(">", "\\>")
      |> String.replace("_", "\\_")

    embed = %Embed{
      title: "I escaped this for you :)",
      description: escaped
    }

    Api.create_message!(msg.channel_id, embed: embed)
  end
end
