defmodule Hangman.Runtime.Application do
  @moduledoc false

  @super_name GameStarter

  use Application

  @impl true
  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @super_name}
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(supervisor_spec, opts)
  end

  def start_game() do
    DynamicSupervisor.start_child(@super_name, {Hangman.Runtime.Server, nil})
  end
end
