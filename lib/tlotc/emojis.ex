defmodule TLotC.Emojis do
  alias TLotC.Helpers
  alias Nostrum.Api
  alias Nostrum.Struct.Emoji
  alias Nostrum.Struct.Guild

  def recursive_parse([], acc, _), do: acc
  def recursive_parse([">" | es], acc, new), do: recursive_parse(es, [new | acc], "")
  def recursive_parse(["<" | es], acc, _), do: recursive_parse(es, acc, "")
  def recursive_parse([c | es], acc, new), do: recursive_parse(es, acc, new <> c)

  def parse_emojis(emojis) do
    emojis
    |> String.graphemes()
    |> recursive_parse([], "")
    |> Stream.map(fn e -> String.split(e, ":") end)
    |> Stream.map(fn [a | [n | [i | _]]] ->
      %Emoji{id: i, name: n, animated: String.length(a) > 0}
    end)
    |> Enum.filter(&(!&1.animated))
  end

  def add_new_emojis(emojis) do
    Application.ensure_all_started(:inets)

    emojis
    |> parse_emojis
    |> Enum.each(fn e ->
      url = Emoji.image_url(e)

      {:ok, response} = :httpc.request(:get, {url, []}, [], body_format: :binary)
      {{_, 200, 'OK'}, _headers, body} = response

      image = "data:image/png;base64," <> Base.encode64(body)

      Api.create_guild_emoji!(Helpers.guild(), name: e.name, image: image, roles: [])
      :timer.sleep(2100)
    end)
  end

  def remove_old_emojis() do
    Helpers.guild()
    |> Api.list_guild_emojis!()
    |> Enum.each(fn e ->
      Api.delete_guild_emoji!(Helpers.guild(), e.id, "yeet")
      :timer.sleep(2100)
    end)
  end

  def update_emojis(emojis) do
    remove_old_emojis()
    add_new_emojis(emojis)
  end
end
