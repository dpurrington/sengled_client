defmodule SengledClient.WssConnectionSupervisor do
  use DynamicSupervisor

  alias SengledClient.WssConnection

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child() do
    DynamicSupervisor.start_child(__MODULE__, WssConnection)
  end
end
