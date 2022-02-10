defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  @words "assets/words.txt" |> File.read!()

  @spec random_word() :: String.t()
  def random_word() do
    @words
    |> String.split("\n", trim: true)
    |> Enum.random()
  end
end
