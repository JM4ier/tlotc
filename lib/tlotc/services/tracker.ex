defmodule TLotC.Services.Tracker do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed

  use Task

  def start_link(_opts) do
    {:ok, pid} = Task.start_link(fn -> loop([]) end)
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  defp loop(tracks) do
    tracks = receive do
      {:clear} -> 
        []
      {:put, t} -> 
        [t | tracks]
      {:get, r} -> 
        send(r, {:tracks, tracks})
        tracks
      after
        1000 -> tracks
    end
    tracks = case tracks do
      [t | ts] ->
        {url, code, channel, message} = t
        c = :httpc.request(:get, {url, []}, [], []) |> elem(1) |> elem(0) |> elem(1)
        if c == code do
          Api.create_message(channel, embed: %Embed{
            title: "A tracked URL changed",
            description: "#{message}\n\n#{url}"
          })
          ts
        else
          ts ++ [t]
        end
      _ -> tracks
    end
    :timer.sleep(15_000)
    loop(tracks)
  end

  def add_monitor(url, code, channel, message) do
    send(__MODULE__, {:put, {url, code, channel, message}})
  end

  def get_monitors() do
    send(__MODULE__, {:get, self()})
    receive do
      {:tracks, tracks} -> tracks
    end
  end

end
