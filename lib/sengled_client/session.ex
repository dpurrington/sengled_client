defmodule SengledClient.Session do
  use GenServer

  @mqtt_url "wss://element.cloud.sengled.com/mqtt"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, %{opts: opts}}
  end

  def get_session_id() do
    url = "https://ucenter.cloud.sengled.com/user/app/customer/v2/AuthenCross.json"

    headers = %{
      "Content-Type": "application/json",
      Host: "element.cloud.sengled.com:443",
      Connection: "keep-alive"
    }

    device_id = "foo"
    username = System.fetch_env!("SENGLED_USERNAME")
    password = System.fetch_env!("SENGLED_PASSWORD")

    payload = %{
      uuid: device_id,
      user: username,
      pwd: password,
      osType: "android",
      productCode: "life",
      appCode: "life"
    }

    {:ok, response} = HTTPoison.post(url, Poison.encode!(payload), headers)

    Poison.decode!(response.body)
    |> Map.get("jsessionId")
  end

  def open(pid) do
    GenServer.call(pid, {:open})
  end

  @impl true
  def handle_call({:open}, _from, st) do
    session_id = get_session_id()

    # TODO: do we need a supervisor here?
    connection = SengledClient.WssConnection.start_link(url: @mqtt_url, session_id: session_id)

    {:reply, :ok,
     st
     |> Map.put(:connection, connection)
     |> Map.put(:session_id, session_id)}
  end
end
