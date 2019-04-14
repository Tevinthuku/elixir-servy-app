defmodule ServyTest do
  use ExUnit.Case
  alias Servy.Handler

  doctest Servy
  test "summation" do
    assert 1 + 1 == 2
  end
  test "first" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    
    Accept: */*
    """
  
    assert Handler.handle(request) == """    
        HTTP/1.1 200 OK\n
        Content-Type: text/html\n
        Content-Length: 30\n\n
        Lions, Bears, Cheetahs, Tigers\n
    """
  end
end
