defmodule TLotC.Services.RoleManager do
  use Agent
  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, Emoji, Message.Reaction}
  alias TLotC.Helpers

  @impl true
  def start_link(_opts) do
    Agent.start_link(fn -> %{sel: setup_selection_message()} end, name: __MODULE__)
  end

  defp sel_channel(), do: Application.fetch_env!(:tlotc, :selector)

  defp letter_emoji(number) do
    <<240, 159, 135, 166 + number>>
  end

  defp roles() do
    Api.get_guild_roles!(Helpers.guild())
    |> Enum.filter(&(&1.name =~ "Room"))
    |> Enum.map(& &1.id)
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.map(fn {id, idx} -> {id, letter_emoji(idx)} end)
  end

  defp setup_selection_message() do
    channel = sel_channel()

    messages =
      Api.get_channel_messages!(channel, 100)
      |> Enum.map(& &1.id)

    Api.bulk_delete_messages(channel, messages)

    embed = %Embed{
      title: "Channel Selector",
      description: """
      You can select one channel to have a conversation in.
      React with the appropriate letter to join a channel.
      Messages will be deleted after one hour. (TODO)
      After some inactivity the role will be removed from you. (TODO)
      """
    }

    msg = Api.create_message!(channel, embed: embed)

    Enum.map(roles(), fn {_, emoji} ->
      Api.create_reaction!(channel, msg.id, emoji)
      :timer.sleep(1100)
    end)
  end

  @spec on_reaction_add(Reaction.t()) :: :ok | no_return()
  def on_reaction_add(reaction) do
    if reaction.channel_id == sel_channel() do
      roles = roles()

      # remove all existing roles from the person
      person = reaction.member.user.id

      # find new role and add if it exists
      role =
        Enum.reduce(roles, nil, fn {role, letter}, acc ->
          if letter == reaction.emoji.name, do: role, else: acc
        end)

      if role do
        Api.add_guild_member_role(Helpers.guild(), person, role)

        Enum.map(roles, fn {rrole, _} ->
          if rrole != role do
            Api.remove_guild_member_role(Helpers.guild(), person, rrole)
            :timer.sleep(1100)
          end
        end)
      end

      IO.puts("#{inspect(reaction)}")
      # Api.delete_reaction(reaction.channel_id, reaction.message_id, reaction.emoji)
    end

    :ok
  end
end
