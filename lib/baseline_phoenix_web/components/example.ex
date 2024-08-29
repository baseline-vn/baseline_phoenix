defmodule BaselinePhoenixWeb.Components.Example do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <LiveSvelte.svelte name="Example" />
    """
  end
end
