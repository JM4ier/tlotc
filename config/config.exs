use Mix.Config

config :nostrum,
  token: File.read("config/token.txt") |> elem(1),
  num_shards: :auto,
  gateway_intents: [:guild_members],
  audio_timeout: 20000,
  audio_running_timeout: 2000

config :porcelain,
  driver: Porcelain.Driver.Basic

config :nosedrum,
  prefix: "."

config :tlotc,
  guild: 842_112_900_839_112_714,
  selector: 842_112_900_839_112_717,
  owner: 177_498_563_637_542_921
