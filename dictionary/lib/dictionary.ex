defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  alias Dictionary.Runtime.Server

  @opaque t() :: Server.t()

  @spec start_link() :: {:ok, t}
  defdelegate start_link, to: Server, as: :start_link

  @spec random_word(t()) :: binary()
  defdelegate random_word(pid), to: Server
end
