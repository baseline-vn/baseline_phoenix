defmodule BaselinePhoenixWeb.Components.BaselineUI.LinkSidebar do
  @moduledoc false

  use Phoenix.Component

  attr :path, :string, required: true
  attr :class, :string, default: ""
  slot :inner_block, required: true
  attr :starts_with, :string, default: ""
  attr :active_class, :string, default: "active"
  attr :inactive_class, :string, default: "inactive"
  attr :conn, :map, required: false

  def link_sidebar(assigns) do
    current_path = Phoenix.Controller.current_path(assigns.conn)
    active =
      if String.length(assigns.starts_with) > 0,
        do: String.starts_with?(current_path, assigns.starts_with),
        else: current_path == assigns.path

    classes =
      if(active, do: assigns.active_class, else: assigns.inactive_class)

    assigns = assign(assigns, active: active, classes: classes)

    ~H"""
    <.link
      navigate={@path}
      class={[
        "border-l-[3px] font-medium hover:bg-primary-100 hover:border-primary-500 hover:text-green-500 pl-7 py-2 text-gray-600",
        @classes
      ]}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
