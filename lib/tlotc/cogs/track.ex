defmodule TLotC.Cogs.Track do
  alias Nostrum.Api
  alias TLotC.Helpers

  @behaviour Nosedrum.Command

  @impl true
  def predicates, do: [&TLotC.Predicates.owner_only/1]

  @impl true
  def usage,
    do: ["URL HTTP_CODE NOTIFY_MESSAGE"]

  @impl true
  def description,
    do: """
        This command adds an url to the tracking list.
    """

  @impl true
  def command(msg, [url | [code | rest]]) do
    {code, _} = Integer.parse(code)
    TLotC.Services.Tracker.add_monitor(url, code, msg.channel_id, Enum.join(rest, " "))
  end

  def command(msg, _) do
    Api.create_message(msg.channel_id, "wrong usage.")
  end

end
