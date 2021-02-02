defmodule Deerbot.Events do
  use Alchemy.Events
  alias Alchemy.Client

  @emoji Application.fetch_env!(:deerbot, :reaction_emoji)
  @reaction_phrase Application.fetch_env!(:deerbot, :reaction_phrase)
  @reaction_percentage 50

  Events.on_message(:deer_message)
  @spec deer_message(Alchemy.Message.t())::any()
  def deer_message(message) do
    case message.content do
      @emoji ->
        message.channel_id |> send_deer_message_randomly()
      _ ->
        :none
    end
  end

  Events.on_reaction_add(:deer_reaction)
  @spec deer_reaction(String.t(), String.t(), String.t(), Alchemy.Message.emoji()):: any()
  def deer_reaction(_user_id, channel_id, _message_id, emoji) do
    case emoji["name"] do
      @emoji ->
        channel_id |> send_deer_message_randomly()
      _ ->
        :none
    end
  end

  defp send_deer_message_randomly(channel_id) do
    case 1..100 |> Enum.random() do
      deer when deer in 1..@reaction_percentage -> channel_id |> Client.send_message(@reaction_phrase, tts: false, embed: nil, file: nil)
      _ -> :none
    end
  end
end
