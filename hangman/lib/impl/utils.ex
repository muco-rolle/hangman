defmodule Hangman.Impl.Utils do
  @moduledoc """
  Utils functions
  """

  alias Hangman.Types
  alias Hangman.Impl.Game

  @spec get_tally(Game.t()) :: Types.tally()
  defp get_tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      letters_used: game.letters_used
    }
  end

  @spec return_with_tally(Game.t()) :: {Game.t(), Types.tally()}
  def return_with_tally(game) do
    {game, get_tally(game)}
  end

  @spec reveal_guessed_letters(Game.t()) :: list(binary())

  def reveal_guessed_letters(game) do
    is_letter_used? = fn letters_used, letter -> MapSet.member?(letters_used, letter) end

    Enum.map(game.letters, fn letter ->
      is_letter_used?.(game.letters_used, letter)
      |> maybe_reveal(letter)
    end)
  end

  @spec maybe_reveal(boolean, binary) :: binary
  def maybe_reveal(_letter_used = true, letter), do: letter
  def maybe_reveal(_letter_not_used, _letter), do: "_"
end
