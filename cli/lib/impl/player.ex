defmodule Cli.Impl.Player do
  @moduledoc """
  Documentation for `Player`
  """

  @typep tally :: Hangman.tally()
  @typep game :: Hangman.game()

  @typep state :: {game, tally}

  @spec start() :: :ok
  def start do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    interact({game, tally})
  end

  @spec interact(state) :: atom()

  def interact({_game, _tally: %{game_state: :won}}) do
    IO.puts("Congratutions. You won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking for #{tally.letters |> length} letter word"
  end

  defp feedback_for(_tally = %{game_state: :good_guess}) do
    "Good guess!"
  end

  defp feedback_for(_tally = %{game_state: :bad_guess}) do
    "Bad guess!"
  end

  defp feedback_for(_tally = %{game_state: :letter_already_used}) do
    "Letter already used!"
  end

  @spec current_word(tally()) :: list(binary)
  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      " Turns left: ",
      tally.turns_left |> to_string(),
      " used so far: ",
      tally.letters_used |> Enum.join(",")
    ]
  end

  @spec get_guess :: any
  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
    |> validate_single_letter()
  end

  @spec validate_single_letter(binary) :: any
  def validate_single_letter(letter) do
    case letter |> to_charlist |> length do
      1 -> letter
      _ -> IO.gets("Next letter: ")
    end
  end
end
