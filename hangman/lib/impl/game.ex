defmodule Hangman.Impl.Game do
  @moduledoc """
  Game module documentation
  """

  alias Hangman.Types

  @type t :: %Hangman.Impl.Game{
          turns_left: integer,
          game_state: Types.state(),
          letters: list(String.t()),
          letters_used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    letters_used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word()
    |> new_game()
  end

  @spec new_game(binary) :: t
  def new_game(word) do
    %Hangman.Impl.Game{
      letters: word |> String.codepoints()
    }
  end

  @spec make_move(t, binary) :: {t, Types.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game |> return_with_tally()
  end

  def make_move(game, guess) do
    is_letter_used? = MapSet.member?(game.letters_used, guess)

    accept_guess(game, guess, is_letter_used?)
    |> return_with_tally()
  end

  @spec accept_guess(t, binary, boolean) :: t
  def accept_guess(game, _guess, _letter_already_used = true) do
    %{game | game_state: :letter_already_used}
  end

  def accept_guess(game, guess, _letter_not_used) do
    game = %{game | letters_used: MapSet.put(game.letters_used, guess)}

    good_guess? = Enum.member?(game.letters, guess)

    score_guess(game, good_guess?)
  end

  @spec score_guess(t, boolean) :: t
  def score_guess(game, _good_guess = true) do
    is_game_won? = MapSet.subset?(MapSet.new(game.letters), game.letters_used)

    case is_game_won? do
      true -> %{game | game_state: :won}
      _ -> %{game | game_state: :good_guess}
    end
  end

  def score_guess(game, _bad_guess) do
    case game.turns_left do
      1 -> %{game | game_state: :lost, turns_left: game.turns_left - 1}
      _ -> %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
    end
  end

  #
  # Utils functions
  ##############################################
  @spec tally(Game.t()) :: Types.tally()
  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      letters_used: game.letters_used
    }
  end

  @spec return_with_tally(Game.t()) :: {Game.t(), Types.tally()}
  def return_with_tally(game) do
    {game, tally(game)}
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
