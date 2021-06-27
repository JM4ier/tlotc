defmodule TLotC.Predicates do

    alias Nostrum.Cache.GuildCache
    alias Nostrum.Struct.Message
    alias Nostrum.Voice

    defp in_vc(uid, cid, [%{channel_id: cid, user_id: uid} | _]), do: :passthrough
    defp in_vc(uid, cid, [_ | rest]), do: in_vc(uid, cid, rest)
    defp in_vc(_uid, _cid, _), do: {:error, "Not in voicechat"}

    def same_vc(msg) do
        if vc = Voice.get_channel_id(msg.guild_id) do
            case GuildCache.get(msg.guild_id) do
                {:ok, guild} -> 
                    in_vc(msg.author.id, vc, guild.voice_states)
                {:error, _} ->
                    {:error, "Error retrieving guild"}
            end
        else
            {:error, "The bot needs to be in a voice channel."}
        end
    end

    def owner_only(msg) do
        if msg.author.id == 177498563637542921 do
            :passthrough
        else
            {:error, "This command is for owners only."}
        end
    end

end
