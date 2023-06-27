defmodule SengledClient.WssConnection do
  use WebSockex
  use SengledClient.Publisher, topic: "wss"

  require Logger

  @moduledoc false

  def start_link(opts) do
    url = Keyword.get(opts, :url)
    session_id = Keyword.get(opts, :session_id)

    headers = [
      {<<"X-Requested-With">>, "com.sengled.life2"},
      {<<"Cookie">>, "JSESSIONID=#{session_id}"},
      {<<"sid">>, session_id}
    ]

    WebSockex.start_link(url, __MODULE__, opts, extra_headers: headers)
  end

  def send(client, message) do
    # why?
    WebSockex.send_frame(client, {:text, message})
  end

  def handle_frame({type, msg} = frame, st) do
    IO.inspect("Received message - type: #{inspect(type)} -- message: #{inspect(msg)}")
    __MODULE__.publish(frame)
    {:ok, st}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end
end
