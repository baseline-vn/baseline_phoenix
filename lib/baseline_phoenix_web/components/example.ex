defmodule BaselinePhoenixWeb.Components.Example do
  use Phoenix.Component
  import LiveSvelte

  attr :name, :string, default: "World"

  def render(assigns) do
    ~H"""
    <.svelte name="Example" props={%{name: @name}} />
    """
  end
end
