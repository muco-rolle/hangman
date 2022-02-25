defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  alias Dictionary.Impl.WordList

  @words "assets/words.txt" |> File.read!()

  @spec random_word() :: String.t()
  def random_word() do
    @words
    |> String.split("\n", trim: true)
    |> Enum.random()
  end

  @spec start() :: WordList.words()
  defdelegate start, to: WordList

  @spec random_word(WordList.words()) :: binary()
  defdelegate random_word(words), to: WordList
end
