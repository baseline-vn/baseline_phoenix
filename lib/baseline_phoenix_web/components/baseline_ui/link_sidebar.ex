defmodule BaselinePhoenixWeb.Components.BaselineUI.LinkSidebar do
  @moduledoc false

  use Phoenix.Component

  attr :href, :string, required: true
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def link_sidebar(assigns) do
    ~H"""
    <.link
      href={@href}
      class={[
        "border-l-[3px] font-medium hover:bg-primary-100 hover:border-primary-500 hover:text-green-500 pl-7 py-2 text-gray-600",
        @class
      ]}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
