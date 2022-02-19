defmodule Hangman.Impl.Game do
  @moduledoc """
  Game module documentation
  """

  alias Hangman.{Types, Impl.Utils}

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
    game |> Utils.return_with_tally()
  end

  def make_move(game, guess) do
    is_letter_used? = MapSet.member?(game.letters_used, guess)

    accept_guess(game, guess, is_letter_used?)
    |> Utils.return_with_tally()
  end

  @spec accept_guess(t, binary, boolean) :: t
  def accept_guess(game, _guess, _letter_already_used = true) do
    %{game | game_state: :letter_already_used}
  end

  def accept_guess(game, guess, _letter_not_used) do
    game = %{game | letters_used: MapSet.put(game.letters_used, guess)}

    # _good_guess? = Enum.member?(game.letters, guess)

    good_guess? = Enum.member?(game.letters, guess)

    score_guess(game, good_guess?)
  end

  @spec score_guess(t, boolean) :: t
  def score_guess(game, _good_guess = true) do
    won? = MapSet.subset?(MapSet.new(game.letters), game.letters_used)

    case won? do
      true -> %{game | game_state: :won}
      _ -> %{game | game_state: :good_guess}
    end
  end

  def score_guess(game, _bad_guess) do
    case game.turns_left do
      1 ->
        %{game | game_state: :lost}

      _ ->
        %{
          game
          | game_state: :bad_guess,
            turns_left: game.turns_left - 1
        }
    end
  end
end
