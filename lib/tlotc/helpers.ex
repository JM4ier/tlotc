defmodule TLotC.Helpers do
  alias Nostrum.Api

  def guild(), do: Application.fetch_env!(:tlotc, :guild)
  def owner(), do: Application.fetch_env!(:tlotc, :owner)
  def prefix(), do: Application.fetch_env!(:nosedrum, :prefix)
  def cryo_role(), do: Application.fetch_env!(:tlotc, :cryo_role)
  def online_role(), do: Application.fetch_env!(:tlotc, :online_role)


  def create_room(name) do
    channel = Api.create_guild_channel!(guild(), name: name, topic: "")
    role = Api.create_guild_role!(guild(), name: name, hoist: true)

    allow_see = %{type: "role", allow: 2_147_798_080}
    deny_see = %{type: "role", deny: 2_147_863_616}

    # disable for @everyone
    Api.edit_channel_permissions!(channel.id, guild(), deny_see)

    # enable for that specific role
    Api.edit_channel_permissions!(channel.id, role.id, allow_see)
  end
end
