defmodule Dictionary.Runtime.Server do
  @moduledoc """
  Documentation for `Server`
  """

  alias Dictionary.Impl.WordList

  @type t :: pid()

  @spec start_link :: {:error, any} | {:ok, pid}
  def start_link do
    Agent.start_link(&WordList.word_list/0)
  end

  @spec random_word(pid()) :: binary()
  def random_word(pid) do
    Agent.get(pid, &WordList.random_word/1)
  end
end
