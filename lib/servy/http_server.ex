

defmodule Servy.HttpServer do
    def start(port) when is_integer(port) and port > 1023 do
        {:ok, listen_socket} = :gen_tcp.listen(port,
        [:binary, packet: :raw, active: false , reuseaddr: true])

        IO.puts "Listening for connection requests on port #{port} ... \n"

        accept_loop(listen_socket)
    end

    def accept_loop(listen_socket) do
        IO.puts "Waiting to accept client connections... \n"

        {:ok, client_socket} = :gen_tcp.accept(listen_socket)

        IO.puts "Connection accepted .. \n"

        spawn(fn -> server(client_socket) end)

        accept_loop(listen_socket)
    end

    def server(client_socket) do
        IO.puts "#{inspect self()}"
        client_socket
        |> read_request
        |> Servy.Handler.handle
        |> write_response(client_socket)
    end

    def read_request(client_socket) do
        {:ok, request} = :gen_tcp.recv(client_socket, 0)
        IO.puts "=> Received request: \n"
        IO.puts request

        request
    end

    def write_response(response, client_socket) do
        :ok = :gen_tcp.send(client_socket, response)

        IO.puts "<= Sent response \n"

        IO.puts response

        :gen_tcp.close(client_socket)
    end
end