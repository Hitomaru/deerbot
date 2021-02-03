defmodule Deerbot.Commands do
  use Alchemy.Cogs

  alias Alchemy.Cogs
  @reaction_phrase Application.fetch_env!(:deerbot, :reaction_phrase)

  Cogs.def deerhelp do
    Cogs.say """
     !deer: ｼｶｯｼｶｯとリアクションします
     !choice A B C... 列挙された単語の中からランダムで一つを返します。何かを適当に選びたいときにどうぞ
     !todaysfood おすすめのご飯を表示します
     !dice n m n面ダイスをm個投げたときの結果を返します。999面ダイスを99個投げるところまで対応
     !repo: botのソースコードが置かれたリポジトリへのリンクを表示します
    """
  end

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

  # Cogs.def choice(selections) do
  #   IO.inspect(selections)
  #   # {_command, selections} = message.content |> String.split() |> Enum.split(1)
  #   # case selections |> Enum.count() do
  #   #   n when n in 0..1 -> Cogs.say("選びようがないですね！")
  #   #   _ -> selections |> Enum.random() |> Cogs.say()
  #   # end
  # end

  Cogs.def todaysfood do
    food_name = Application.fetch_env!(:deerbot, :foods) |> Enum.random()
    "#{food_name} \n https://ja.wikipedia.org/wiki/#{food_name}"
    |> Cogs.say()
  end

  @dice_error_message "`!dice {面数(1～999)} {個数(1～99)}` の記法で入力してください"
  Cogs.def dice do
    Cogs.say(@dice_error_message)
  end
  Cogs.def dice(_) do
    Cogs.say(@dice_error_message)
  end
  Cogs.def dice(dice_max, dice_count) do
    format = fn (values, max, count) -> "#{max}d#{count}: (#{values |> Enum.join(",")}) -> #{values |> Enum.sum()}" end
    case {dice_max |> parse_to_integer(), dice_count |> parse_to_integer()} do
      {{:ok, max}, {:ok, count}} when max < 1000 and count < 100 ->
        fn () -> 1..max |> Enum.random() end
        |> Stream.repeatedly()
        |> Enum.take(count)
        |> format.(max, count)
        |> Cogs.say()
      _ ->
        Cogs.say(@dice_error_message)
    end
  end
  Cogs.def dice(_, _ , _) do
    Cogs.say(@dice_error_message)
  end

  @spec parse_to_integer(String.t()) :: {:ok, integer() } | {:error, atom()}
  defp parse_to_integer(string) do
    case string |> Integer.parse() do
      :error -> { :error, :not_a_number }
      {value, _remain} -> { :ok, value }
    end
  end

end
