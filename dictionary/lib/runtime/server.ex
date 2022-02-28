defmodule Dictionary.Runtime.Server do
  @moduledoc """
  Documentation for `Server`
  """

  alias Dictionary.Impl.WordList

  use Agent

  @me __MODULE__

  @type t :: pid()

  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word :: String.t()
  def random_word() do
    if :rand.uniform() < 0.33 do
      Agent.get(@me, fn _ -> exit(:boom) end)
    end

    Agent.get(@me, &WordList.random_word/1)
  end
end
