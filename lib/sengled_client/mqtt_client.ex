defmodule SengledClient.MqttClient do
  alias SengledClient.WssConnection

  def send(socket, topic, message) do
    frame = "#{topic}, #{message}"

    WssConnection.send(socket, frame)
  end
end
