defmodule Dictionary.Impl.WordList do
  @moduledoc """
  Documentation for `WordList`
  """

  @type t :: list(String.t())

  @spec word_list :: t
  def word_list, do: get_words()

  @spec random_word(t) :: binary
  def random_word(words) do
    words |> Enum.random()
  end

  @spec get_words() :: t
  defp get_words() do
    File.cwd!() |> Path.join("assets/words.txt") |> File.read!() |> String.split()
  end
end
