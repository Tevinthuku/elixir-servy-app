defmodule ServyParser do
    use ExUnit.Case
    alias Servy.Parser
    doctest Servy.Parser

    test "full request parsing" do
        request = """
        GET /bears HTTP/1.1
        Host: example.com
        User-Agent: ExampleBrowser/1.0
        Accept: */*
        Content-Type: application/x-www-form-urlencoded

        name=Balloo&type=Brown
        """
        assert Parser.parse(request) == %Servy.Conv{
            headers: %{
              "Accept" => "*/*",
              "Content-Type" => "application/x-www-form-urlencoded",
              "Host" => "example.com",
              "User-Agent" => "ExampleBrowser/1.0"
            },
            method: "GET",
            params: %{"name" => "Balloo", "type" => "Brown"},
            path: "/bears",
            resp_body: "",
            status: nil
          }
    end
end