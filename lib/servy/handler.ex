defmodule Servy.Handler do
    alias Servy.Parser
    alias Servy.Conv
    alias Servy.VideoCam
    alias Servy.BearController
    alias Servy.Fetcher
    @pages_path Path.expand("../../pages", __DIR__)


    def handle(request) do
        request |> Parser.parse |> rewritepath |>route |> format_response
    end

    def rewritepath(%{path: "/wildlife"} = conv) do
        %{ conv | path: "/wildthings" }
    end

    def rewritepath(conv), do: conv

    def route(%Conv{method: "POST", path: "/pledges"} = conv) do
        Servy.PledgeController.create(conv, conv.params)
    end
    def route(%Conv{method: "GET", path: "/pledges"} = conv) do
        Servy.PledgeController.index(conv)
    end
    def route(%{method: "GET", path: "/sensors"} = conv) do

        sensor_data = Servy.SensorServer.get_sensor_data()

        %{conv | status: 200, resp_body: inspect sensor_data }
    end
    def route(%{method: "GET", path: "/hibernate/" <> time} = conv) do
        time |> String.to_integer |> :timer.sleep
        %{ conv | status: 200, resp_body: "Awake" }
    end
    def route(%{method: "GET", path: "/wildthings"} = conv) do
        %{ conv | status: 200, resp_body: "Lions, Bears, Cheetahs, Tigers" }
    end
    def route(%{method: "GET", path: "/api/bears"} = conv) do
        Servy.Api.BearController.index(conv)
    end
    def route(%{method: "GET", path: "/bears"} = conv) do
        BearController.index(conv)
    end
    def route(%{method: "GET", path: "/bears/" <> id} = conv) do
        params = Map.put(conv.params, "id", id)
        BearController.show(conv, params)
    end
    def route(%{ method: "GET", path: "/about" } = conv) do
        file = @pages_path
                |> Path.join("about.html")
        case File.read(file) do
            {:ok, content} ->
                %{ conv | status: 200, resp_body: content }

            {:error, :enoent} ->
                %{ conv | status: 404, resp_body: "The file isnt found" }

            {:error, reason} ->
                %{ conv | status: 500, resp_body: "Something went wrong #{reason}" }
        end
    end
    def route(%{ method: "POST", path: "/bears" } = conv) do
        BearController.create(conv, conv.params)
    end
    def route(%{ path: path } = conv) do
        %{ conv | status: 404, resp_body: "No #{path} here " }
    end

    def format_response(%Conv{} = conv) do
        """
            HTTP/1.1 #{Conv.full_request(conv)}
            Content-Type: #{conv.resp_content_type}
            Content-Length: #{String.length(conv.resp_body)}

            #{conv.resp_body}
        """
    end

    defp status_reason(code) do
        %{
            200 => "OK",
            201 => "Created",
            401 => "Unauthorized",
            403 => "Forbidden",
            404 => "Not found",
            500 => "Internal Server Error"
        }[code]
    end
end


