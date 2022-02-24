defmodule Cli do
  @moduledoc """
  Documentation for `Cli`.
  """

  alias Cli.Impl.Player

  @spec start :: atom()
  defdelegate start, to: Player
end
