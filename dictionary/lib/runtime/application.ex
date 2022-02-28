defmodule Dictionary.Runtime.Application do
  @moduledoc """
  Documentation for `Application`
  """

  use Application

  alias Dictionary.Runtime.Server

  def start(_type, _args) do
    Server.start_link()
  end
end
