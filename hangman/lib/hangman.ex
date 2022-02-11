defmodule Hangman do
  @moduledoc """
  Documentation for `Hangman`.
  """

  alias Hangman.{Impl.Game, Types}

  @opaque game :: Game.t()

  @spec new_game :: game
  defdelegate new_game, to: Game

  @spec make_move(game, binary) :: {game, Types.tally()}
  defdelegate make_move(game, guess), to: Game
end
