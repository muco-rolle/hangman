defmodule Dictionary.Impl.WordList do
  @moduledoc """
  Documentation for `WordList`
  """

  @opaque words :: list(binary)

  @spec start :: words()
  def start, do: get_words()

  @spec random_word(words) :: binary
  def random_word(words) do
    words |> Enum.random()
  end

  @spec get_words() :: words()
  defp get_words() do
    File.cwd!() |> Path.join("assets/words.txt") |> File.read!() |> String.split()
  end
end
