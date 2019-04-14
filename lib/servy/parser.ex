defmodule Servy.Parser do
    alias Servy.Conv

    def parse(request) do
        [top, params_string] = String.split(request, "\r\n\r\n")
        [request_line | header_lines] = String.split(top, "\r\n")

        [method, path, _] = String.split(request_line, " ")
        headers = parse_headers(header_lines, %{})
        params = parse_params(headers["Content-Type"],params_string)
        
        %Conv{method: method, path: path, params: params, headers: headers}
    end
  @doc """
  Parses the given `params` into a map.

  ## Examples

      iex> param_string = "name=Baloo&type=Brown"
      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", param_string)
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy.Parser.parse_params("application/multipart", param_string)
      %{}

  """
    def parse_params("application/x-www-form-urlencoded",param_string) do
        param_string |> String.trim |> URI.decode_query
    end
    def parse_params(_,_), do: %{}



    @doc """
    Parse list of headers to a map

    ## Examples

        iex> param_header = ["Authorization: Bearer tokenhere"]
        iex> Servy.Parser.parse_headers(param_header, %{})
        %{"Authorization" => "Bearer tokenhere"}

    """
    def parse_headers([head | tail], headersmap) do
        [key, value] = String.split(head, ": ")
        headers = Map.put(headersmap, key, value)
        parse_headers(tail, headers)
    end
    def parse_headers([], headersmap), do: headersmap
end