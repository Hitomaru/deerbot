defmodule Deerbot do
  @moduledoc """
  Documentation for `Deerbot`.
  """

  use Application

  def start(_type, _args) do
    run = Alchemy.Client.start(Application.fetch_env!(:deerbot, :discord_token))
    use Deerbot.Commands
    use Deerbot.Events
    run
  end
end
