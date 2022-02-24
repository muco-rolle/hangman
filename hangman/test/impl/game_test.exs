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

    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess

    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter is not in the word" do
    game = Game.new_game("wombat")

    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess

    {_game, tally} = Game.make_move(game, "w")
    assert tally.game_state == :good_guess

    {_game, tally} = Game.make_move(game, "d")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of move" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], MapSet.new(["a"])],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], MapSet.new(["a", "e"])],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], MapSet.new(["a", "e", "x"])]
    ]
    |> test_sequence_of_moves
  end

  test "can handle a winning game" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], MapSet.new(["a"])],
      ["a", :letter_already_used, 6, ["_", "_", "_", "_", "_"], MapSet.new(["a"])],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], MapSet.new(["a", "e"])],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], MapSet.new(["a", "e", "x"])],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], MapSet.new(["a", "e", "x", "l"])],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], MapSet.new(["a", "e", "x", "l", "o"])],
      [
        "y",
        :bad_guess,
        4,
        ["_", "e", "l", "l", "o"],
        MapSet.new(["a", "e", "x", "l", "o", "y"])
      ],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], MapSet.new(["a", "e", "x", "l", "o", "y", "h"])]
    ]
    |> test_sequence_of_moves
  end

  test "can handle a failing game" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], MapSet.new(["a"])],
      ["h", :good_guess, 6, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h"])],
      ["h", :letter_already_used, 6, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h"])],
      ["t", :bad_guess, 5, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h", "t"])],
      ["s", :bad_guess, 4, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h", "t", "s"])],
      ["m", :bad_guess, 3, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h", "t", "s", "m"])],
      ["n", :bad_guess, 2, ["h", "_", "_", "_", "_"], MapSet.new(["a", "h", "t", "s", "m", "n"])],
      [
        "b",
        :bad_guess,
        1,
        ["h", "_", "_", "_", "_"],
        MapSet.new(["a", "h", "t", "s", "m", "n", "b"])
      ],
      [
        "g",
        :lost,
        0,
        ["h", "e", "l", "l", "o"],
        MapSet.new(["a", "h", "t", "s", "m", "n", "b", "g"])
      ]
    ]
    |> test_sequence_of_moves
  end

  #
  # Helper test functions
  ###########################################
  defp test_sequence_of_moves(script) do
    game = Game.new_game("hello")

    script |> Enum.reduce(game, &test_one_move/2)
  end

  defp test_one_move([guess, state, turns, letters, letters_used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert MapSet.equal?(tally.letters_used, letters_used)

    game
  end
end
