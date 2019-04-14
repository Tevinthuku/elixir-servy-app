defmodule Servy.Tracker do

    def get_location(wildthing) do
        :timer.sleep(500)


        locations = %{
            "roscoe" => %{ lat: "44.4280 N", lng: "110.5885 W" },
            "smokie" => %{ lat: "48.7596 N", lng: "110.5885 W" },
            "brutus" => %{ lat: "4.480 N", lng: "110.5885 W" },
            "bigfoot" => %{ lat: "29.4280 N", lng: "98.5885 W" },
        }

        Map.get(locations, wildthing)
    end
end