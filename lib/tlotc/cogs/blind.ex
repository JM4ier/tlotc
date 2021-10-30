defmodule TLotC.Cogs.Blind do
  alias Nostrum.Api
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
        This command revokes your access to any channel on this server.
        Also see `#{Helpers.prefix()}unblind`
    """

  @impl true
  def command(msg, _args) do
    Api.add_guild_member_role(Helpers.guild(), msg.author.id, Helpers.blind_role())
  end

end
