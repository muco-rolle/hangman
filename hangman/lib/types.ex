defmodule Hangman.Types do
  @moduledoc """
  Hangman Types
  """

  @type game :: Hangman.Impl.Game.t()
  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :letters_already_used
  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String.t()),
          letters_used: MapSet.t(list(String.t()))
        }
end
