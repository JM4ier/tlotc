defmodule TLotC.Consumer.MessageReactionAdd do

    alias Nostrum.Api
    alias Nostrum.Struct.Message.Reaction
    alias TLotC.Services.RoleManager

    def handle(reaction) do
        RoleManager.on_reaction_add(reaction)
        :ok
    end
end
