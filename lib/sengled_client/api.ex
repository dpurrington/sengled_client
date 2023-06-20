defmodule SengledClient.Api do
  alias SengledClient.Device

  def get_session_id(username, password) do
    url = "https://ucenter.cloud.sengled.com/user/app/customer/v2/AuthenCross.json"

    headers = %{
      "Content-Type": "application/json",
      Host: "element.cloud.sengled.com:443",
      Connection: "keep-alive"
    }

    device_id = "foo"

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

  # invalid or expired token response

  #  %{
  #    "description" => "Session过期",
  #    "ifCheckSessionid" => nil,
  #    "info" => "Session expire",
  #    "messageCode" => "20005",
  #    "snapServiceMinVerison" => nil
  #  }

  # valid token response

  # %{
  #  "description" => "一切正常",
  #  "ifCheckSessionid" => 0,
  #  "info" => "OK",
  #  "messageCode" => "200",
  #  "snapServiceMinVerison" => 0
  # }
  def session_id_expired?(session_id) do
    url = "https://ucenter.cloud.sengled.com/user/app/customer/isSessionTimeout.json"

    payload = %{
      uuid: "foo",
      os_type: "android",
      appCode: "life"
    }

    headers = %{
      "Content-Type": "application/json",
      Cookie: "JSESSIONID=#{session_id}",
      sid: session_id,
      "X-Requested-With": "com.sengled.life2"
    }

    {:ok, response} = HTTPoison.post(url, Poison.encode!(payload), headers)

    body = Poison.decode!(response.body)

    case body["info"] do
      "OK" -> false
      _ -> true
    end
  end

  def get_devices(session_id) do
    url = "https://life2.cloud.sengled.com/life2/device/list.json"

    headers = %{
      "Content-Type": "application/json",
      Cookie: "JSESSIONID=#{session_id}",
      sid: session_id,
      "X-Requested-With": "com.sengled.life2"
    }
    {:ok, %{status_code: 200} = response} = HTTPoison.post(url, "{}", headers)
    body = Poison.decode!(response.body)
    body["deviceList"] |> Enum.map(&Device.from_response/1)
  end
end
