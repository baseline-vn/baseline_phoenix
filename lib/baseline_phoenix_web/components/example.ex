defmodule BaselinePhoenixWeb.Components.Example do
  use Phoenix.Component
  import LiveSvelte

  def render(assigns) do
    ~H"""
    <.svelte name="Example" props={%{name: "@number"}} />
    """
  end
end
