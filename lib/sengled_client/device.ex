defmodule SengledClient.Device do
  defstruct ~w[attribute_list category device_animations device_uuid type_code]a

  def from_response(%{} = response) do
    %__MODULE__{
      attribute_list:
        response["attributeList"]
        |> Enum.into(%{}, fn elem -> {elem["name"], elem["value"]} end),
      category: response["category"],
      device_animations: response["deviceAnimations"],
      device_uuid: response["deviceUuid"],
      type_code: response["typeCode"]
    }
  end
end
