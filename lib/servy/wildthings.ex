defmodule Servy.Wildthings do
    alias Servy.Bear

    def list_bears do
        [
            %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Ballo", type: "Brown", hibernating: true},
            %Bear{id: 1, name: "Sheer", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Khan", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Grizz", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Hue Glass", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Biggy", type: "Brown", hibernating: false},
            %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: false},
        ]
    end

    def transform_bear_to_HTMLli(b) do
        "<li>My Name is #{b.name} : My Type is #{b.type}</li>"
    end

    def get_bear(id) when is_integer(id) do
        Enum.find(list_bears(), fn(b) -> b.id == id end)
    end

    def get_bear(id) when is_binary(id) do
        id |> String.to_integer |> get_bear
    end

    
end