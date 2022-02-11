defmodule HangmanImpleGameTest do
  @moduledoc """
  Game module test file
  """
  alias Hangman.Impl.Game

  use ExUnit.Case
  doctest Hangman

  test "new game returns a structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 1
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end
end
