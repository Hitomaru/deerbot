defmodule Deerbot.Commands do
  use Alchemy.Cogs

  alias Alchemy.Cogs
  @reaction_phrase Application.fetch_env!(:deerbot, :discord_token)

  Cogs.def deer do
    Cogs.say @reaction_phrase
  end

  Cogs.def repo do
    Cogs.say Application.fetch_env!(:deerbot, :repo_url)
  end

  Cogs.def choice do
    {_command, selections} = message.content |> String.split() |> Enum.split(1)
    case selections |> Enum.count() do
      n when n in 0..1 -> Cogs.say("選びようがないですね！")
      _ -> selections |> Enum.random() |> Cogs.say()
    end
  end

  Cogs.def todaysfood do
    food_name = Application.fetch_env!(:deerbot, :foods) |> Enum.random()
    "#{food_name} \n https://ja.wikipedia.org/wiki/#{food_name}"
    |> Cogs.say()
  end

end
