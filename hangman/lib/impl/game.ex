defmodule Hangman.Impl.Game do
  @moduledoc """
  Game module documentation
  """

  alias Hangman.Impl.Types

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
end
