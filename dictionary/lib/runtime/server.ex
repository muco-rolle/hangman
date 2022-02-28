defmodule Dictionary.Runtime.Server do
  @moduledoc """
  Documentation for `Server`
  """

  alias Dictionary.Impl.WordList

  @me __MODULE__

  @type t :: pid()

  @spec start_link :: {:error, any} | {:ok, pid}
  def start_link do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word() :: String.t()
  def random_word() do
    Agent.get(@me, &WordList.random_word/1)
  end
end
