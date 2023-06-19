defmodule SengledClient.Publisher do
  defmacro __using__(opts) do
    topic = Keyword.get(opts, :topic)

    quote do
      def publish(message) do
        # send the message to all subscribers
        case :pg.get_members(unquote(topic)) do
          [_ | _] = members ->
            members
            |> Enum.each(&send(&1, message))

          _ ->
            nil
        end

        :ok
      end

      def subscribe(), do: :pg.join(unquote(topic), self())
    end
  end
end
