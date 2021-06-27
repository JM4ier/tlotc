use Mix.Config

config :nostrum,
  token: File.read("config/token.txt") |> elem(1),
  num_shards: :auto,
  audio_timeout: 20000,
  audio_running_timeout: 2000


config :porcelain,
    driver: Porcelain.Driver.Basic

config :nosedrum,
    prefix: "."

config :tlotc,
    guild: 842112900839112714,
    selector: 842112900839112717
