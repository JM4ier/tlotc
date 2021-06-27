defmodule TLotC.Cogs.Help do

    @behaviour Nosedrum.Command

    alias Nosedrum.Storage.ETS, as: Commands
    alias Nostrum.Api
    alias Nostrum.Struct.Embed

    defp prefix() do
        Application.fetch_env!(:nosedrum, :prefix)
    end

    @impl true
    def predicates, do: []

    @impl true
    def usage, do: [
        "",
        "help"
    ]

    @impl true
    def description, do: "Displays a help page for all commands"

    @impl true
    def command(msg, []) do
        embed = %Embed{
            title: "A list of all commands",
            description:
                   Commands.all_commands()
                |> Map.keys()
                |> Stream.map(&"`#{prefix()}#{&1}`")
                |> (fn cmds -> 
                        """
                        #{Enum.join(cmds, ", ")}

                        Help to specific commands can be obtained with `#{prefix()}help <command>`
                        """
                end).()
        }
        {:ok, _} = Api.create_message(msg.channel_id, embed: embed)
    end

    def command(msg, [cmd]) do
        cmd = String.replace(cmd, prefix(), "")
        msg = case Commands.lookup_command(cmd) do
            nil ->
                Api.create_message(msg.channel_id, "I don't know this command. Get a list of commands with `#{prefix()}help`")

            command when not is_map(command) ->
                embed = %Embed{
                    title: "Help to #{cmd}",
                    description: """
                    ```
                    #{
                           command.usage()
                        |> Stream.map(&"#{prefix() <> cmd} #{&1}")
                        |> Enum.join("\n")
                    }
                    ```
                    #{command.description()}
                    """
                }
                Api.create_message(msg.channel_id, embed: embed)

            _ ->
                Api.create_message(msg.channel_id, "I don't know how to handle this.")
        end
        {:ok, _} = msg
    end

    def command(msg, _args) do
        {:ok, _} = Api.create_message(msg.channel_id, "I don't know what you want from me.")
    end

end
