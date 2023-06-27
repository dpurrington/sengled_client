```
%{
  "customerId" => 1834796,
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
```

## Device list structure
* customerId
* description
* info
* messageCode
* sceneList
* success
* timeZoneRecordList
* deviceList
    * attributeList
    * category
    * deviceAnimations
    * deviceUuid
    * typeCode

d["attributeList"] |> Enum.into(%{}, fn e -> { e["name"], e["value]} end)
# attributes to a map
d["attributeList"] |> Enum.into(%{}, fn elem -> { elem["name"], elem["value"]}end)

# Transport spec & usage
* new
* new(opts)

## Used
* connect -- Connection
* send -- Pipe, Connection
* recv -- Connection
* setopts -- Receiver
* getstat -- Telemetry
* controlling_process - Receiver (subscribe?)
## Not used
* listen(opts) -- not used
* accept -- not used
* accept_ack -- not used
* getopts -- not used
* peername - not used
* sockname - not used
* shutdown - not used
* close - not used

# silver searcher cheat sheet
--hidden : include hidden files
--ignore : ignore files/directories matching PATTERN, put pattern in quotes to avoid expansion
-G REGEX : search only files whose names match the regex
-C # : number of lines of context to print before and after
--pager PAGERNAME : use a pager for output