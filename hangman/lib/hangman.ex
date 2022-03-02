defmodule Hangman do
  @moduledoc """
  Documentation for `Hangman`.
  """

  alias Hangman.{Types, Runtime.Server}

  @opaque game :: Server.t()

  @spec new_game :: game
  def new_game do
    {:ok, pid} = Hangman.Runtime.Application.start_game()

    pid
  end

  @spec make_move(game, binary) :: {game, Types.tally()}
  def make_move(game, guess) do
    GenServer.call(game, {:make_move, guess})
  end

  @spec tally(game) :: Types.tally()
  def tally(game) do
    GenServer.call(game, {:tally})
  end
end
