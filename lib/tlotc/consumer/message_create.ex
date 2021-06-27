defmodule TLotC.Consumer.MessageCreate do

    alias Nosedrum.Invoker.Split, as: CommandInvoker
    alias Nostrum.Struct.Message
    alias TLotC.Helpers
    
    @spec handle(Message.t()) :: :ok
    def handle(msg) do
        if !msg.author.bot && msg.guild_id == Helpers.guild do
            case CommandInvoker.handle_message(msg, Nosedrum.Storage.ETS) do
                {:error, error} ->
                    IO.puts "An error has occured: #{error}"
                :ignored ->
                    :ok
                _ ->
                    Nostrum.Api.delete_message!(msg)
                    :ok
            end
        end
    end
end
