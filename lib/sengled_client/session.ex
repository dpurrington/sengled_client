defmodule SengledClient.Session do
  use GenServer

  alias SengledClient.Api

  @mqtt_url "wss://element.cloud.sengled.com/mqtt"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    username = System.fetch_env!("SENGLED_USERNAME")
    password = System.fetch_env!("SENGLED_PASSWORD")

    {:ok, %{opts: opts, username: username, password: password}, {:continue, :open}}
  end

  @impl true
  def handle_continue(:open, %{username: username, password: password} = st) do
    session_id = Api.get_session_id(username, password)

    # TODO: do we need a supervisor here?
    connection = SengledClient.WssConnection.start_link(url: @mqtt_url, session_id: session_id)

    {:noreply,
     st
     |> Map.put(:connection, connection)
     |> Map.put(:session_id, session_id)}
  end
end
