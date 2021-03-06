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
  guild: 842_112_900_839_112_714,
  selector: 842_112_900_839_112_717,
  owner: 177_498_563_637_542_921,
  online_role: 858023329373618176,
  cryo_role: 903910766590169140
