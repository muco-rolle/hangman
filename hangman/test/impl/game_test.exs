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

  test "state does not change if game is won / lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")

      game = game |> Map.put(:game_state, state)

      {new_game, _tally} = Game.make_move(game, "x")

      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :letter_already_used

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :letter_already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :letter_already_used
  end

  test "we record letters used" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")

    {game, _tally} = Game.make_move(game, "y")

    {game, _tally} = Game.make_move(game, "x")

    assert MapSet.equal?(game.letters_used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")

    {game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess

    {game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
  end
end
