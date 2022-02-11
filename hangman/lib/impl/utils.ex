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
      letters: [],
      letters_used: game.letters_used
    }
  end

  @spec return_with_tally(Game.t()) :: {Game.t(), Types.tally()}
  def return_with_tally(game) do
    {game, get_tally(game)}
  end
end
