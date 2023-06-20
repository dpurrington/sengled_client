defmodule SengledClient.ApiTest do
  use ExUnit.Case
  import Mock

  alias SengledClient.Api

  @sample_response %{
    "customerId" => 1_834_796,
    "description" => "正常",
    "deviceList" => [
      %{
        "attributeList" => [
          %{"name" => "brightness", "value" => "100"},
          %{"name" => "color", "value" => "0:0:0"},
          %{"name" => "colorMode", "value" => "2"},
          %{"name" => "colorTemperature", "value" => "17"},
          %{"name" => "consumptionTime", "value" => "22461643"},
          %{"name" => "deviceRssi", "value" => "-47"},
          %{"name" => "effectStatus", "value" => "0"},
          %{"name" => "identifyNO", "value" => "ESP8266"},
          %{"name" => "name", "value" => "Office Bulb 2"},
          %{"name" => "online", "value" => "1"},
          %{"name" => "productCode", "value" => "wifielement"},
          %{"name" => "startTime", "value" => "2023-01-02 19:10:23"},
          %{
            "name" => "supportAttributes",
            "value" => "color,colorTemperature,brightness"
          },
          %{"name" => "switch", "value" => "0"},
          %{"name" => "timeZone", "value" => "America/New_York"},
          %{"name" => "typeCode", "value" => "W31-N15"},
          %{"name" => "update", "value" => "success"},
          %{"name" => "version", "value" => "V1.0.1.2"}
        ],
        "category" => "wifielement",
        "deviceAnimations" => [],
        "deviceUuid" => "40:22:D8:8D:85:13",
        "typeCode" => "W31-N15"
      },
      %{
        "attributeList" => [
          %{"name" => "brightness", "value" => "100"},
          %{"name" => "color", "value" => "224:16:25"},
          %{"name" => "colorMode", "value" => "2"},
          %{"name" => "colorTemperature", "value" => "17"},
          %{"name" => "consumptionTime", "value" => "16568176"},
          %{"name" => "deviceRssi", "value" => "-44"},
          %{"name" => "effectStatus", "value" => "0"},
          %{"name" => "identifyNO", "value" => "ESP8266"},
          %{"name" => "name", "value" => "Bulb 1"},
          %{"name" => "online", "value" => "1"},
          %{"name" => "productCode", "value" => "wifielement"},
          %{"name" => "reset", "value" => "1"},
          %{"name" => "startTime", "value" => "2022-12-28 15:18:08"},
          %{
            "name" => "supportAttributes",
            "value" => "color,colorTemperature,brightness"
          },
          %{"name" => "switch", "value" => "0"},
          %{"name" => "timeZone", "value" => "America/New_York"},
          %{"name" => "typeCode", "value" => "W31-N15"},
          %{"name" => "update", "value" => "success"},
          %{"name" => "version", "value" => "V1.0.1.2"}
        ],
        "category" => "wifielement",
        "deviceAnimations" => [],
        "deviceUuid" => "40:22:D8:8B:61:25",
        "typeCode" => "W31-N15"
      }
    ],
    "info" => "OK",
    "messageCode" => "200",
    "sceneList" => nil,
    "success" => true,
    "timeZoneRecordList" => nil
  }

  test "get_session_id/0" do
    with_mock HTTPoison,
      post: fn url, payload, headers ->
        assert url == "https://ucenter.cloud.sengled.com/user/app/customer/v2/AuthenCross.json"
        payload = Poison.decode!(payload)
        assert "username" == payload["user"]
        assert "password" == payload["pwd"]

        assert "application/json" == headers[:"Content-Type"]
        assert "keep-alive" == headers[:Connection]
        assert "element.cloud.sengled.com:443" == headers[:Host]
        {:ok, %HTTPoison.Response{body: "{\"jsessionId\": \"foo\"}"}}
      end do
      assert Api.get_session_id("username", "password") == "foo"
    end
  end

  test "session_id_expired?/1 valid" do
    with_mock HTTPoison,
      post: fn url, payload, _headers ->
        assert url == "https://ucenter.cloud.sengled.com/user/app/customer/isSessionTimeout.json"
        payload = Poison.decode!(payload)
        assert "foo" = payload["uuid"]
        {:ok, %HTTPoison.Response{body: "{\"info\": \"OK\"}"}}
      end do
      assert Api.session_id_expired?("foo") == false
    end
  end

  test "session_id_expired?/1 invalid" do
    with_mock HTTPoison,
      post: fn url, payload, _headers ->
        assert url == "https://ucenter.cloud.sengled.com/user/app/customer/isSessionTimeout.json"
        payload = Poison.decode!(payload)
        assert "foo" = payload["uuid"]
        {:ok, %HTTPoison.Response{body: "{\"info\": \"not ok\"}"}}
      end do
      assert Api.session_id_expired?("foo") == true
    end
  end

  test "get_devices/1" do
    with_mock HTTPoison,
      post: fn url, _payload, headers ->
        assert url == "https://life2.cloud.sengled.com/life2/device/list.json"
        assert "application/json" == headers[:"Content-Type"]
        assert "JSESSIONID=session_id" == headers[:Cookie]
        assert "session_id" == headers[:sid]
        {:ok, %HTTPoison.Response{status_code: 200, body: Poison.encode!(@sample_response)}}
      end do
      devices = Api.get_devices("session_id")
      assert 2 == length(devices)
    end
  end
end
