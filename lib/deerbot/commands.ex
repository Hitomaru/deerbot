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
end
