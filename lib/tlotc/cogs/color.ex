defmodule TLotC.Cogs.Color do
  alias Nostrum.Api
  alias TLotC.Helpers

  @behaviour Nosedrum.Command

  @impl true
  def predicates, do: []

  @impl true
  def usage,
    do: [
      "#FF00FF",
      "#069420",
      ""
    ]

  @impl true
  def description,
    do: """
    This command changes the color of your name on this server, you can choose any hex code. To remove the color you can invoke the command without any arguments.
    """

  defp remove_color(user_id) do
    member = Api.get_guild_member!(Helpers.guild(), user_id)

    Api.get_guild_roles!(Helpers.guild())
    |> Enum.filter(fn role -> String.starts_with?(role.name, "#") && role.id in member.roles end)
    |> Enum.each(fn role -> Api.delete_guild_role(Helpers.guild(), role.id) end)
  end

  @impl true
  def command(msg, [col]) do
    remove_color(msg.author.id)

    # parse color argument
    col = col |> String.replace("#", "") |> Integer.parse(16) |> elem(0)
    col_name = "#" <> (col |> Integer.to_string(16) |> String.pad_leading(6, "0"))

    # create & add new color role
    new_role =
      Api.create_guild_role!(Helpers.guild(),
        name: col_name,
        color: col,
        mentionable: false,
        permissions: 0
      )

    Api.add_guild_member_role(Helpers.guild(), msg.author.id, new_role.id)
  end

  def command(msg, _) do
    remove_color(msg.author.id)
  end
end
