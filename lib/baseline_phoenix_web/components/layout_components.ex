defmodule BaselinePhoenixWeb.LayoutComponents do
  use Phoenix.Component
  import Phoenix.Component
  import BaselinePhoenixWeb.Gettext

  attr :path_info, :list, default: []
  attr :current_user, :map

  def nav(assigns) do
    ~H"""
    <%= if "admin" in @path_info do %>
      <div class="w-full p-2 bg-teal-950 text-white font-medium text-sm">
        <div class="container mx-auto flex justify-between">
          <div>
            <.link
              href="/"
              class="text-[0.8125rem] leading-6 text-white opacity-70 hover:opacity-100 hover:text-white"
            >
              <i class="fa-regular fa-arrow-left mr-2"></i>Go back to platform
            </.link>
          </div>
          <div>Baseline Admin Panel</div>
        </div>
      </div>
    <% end %>
    <ul class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
      <%= if @current_user do %>
        <li class="text-[0.8125rem] leading-6 text-zinc-900">
          <%= @current_user.full_name || @current_user.email || @current_user.phone_number %>
        </li>
        <%= if @current_user.admin do %>
          <li>
            <.link
              href="/admin/dashboard"
              class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Admin
            </.link>
          </li>
        <% end %>
        <li>
          <.link
            href="/log_out"
            method="delete"
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            <%= gettext("Log out") %>
          </.link>
        </li>
      <% else %>
        <li>
          <.link
            href="/sign_in"
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            <%= gettext("Sign in") %>
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end

  attr :icon_name, :string, required: true
  attr :text, :string, required: true
  attr :path, :string, required: true
  attr :request_path, :string, required: true
  attr :starts_with, :string, default: ""
  attr :active_class, :string, default: "active"
  attr :inactive_class, :string, default: "inactive"
  attr :disabled_class, :string, default: "disabled"
  attr :badge, :string, default: ""
  attr :icon_colour, :string, default: "#000"
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  def link_sidebar(assigns) do
    active =
      if String.length(assigns.starts_with) > 0,
        do: String.starts_with?(assigns.request_path, assigns.starts_with),
        else: assigns.path == Phoenix.Controller.current_path(assigns.conn)

    classes =
      if assigns.disabled,
        do: assigns.disabled_class,
        else: if(active, do: assigns.active_class, else: assigns.inactive_class)

    assigns = assign(assigns, active: active, classes: classes)

    ~H"""
    <.link navigate={@path} class={[@class, @classes]} {@rest}>
      <div>
        <.icon name={@icon_name} color={@icon_colour} />
        <span><%= @text %></span>
      </div>
      <%= if @badge do %>
        <span class="bg-pastel-400 text-black text-xs font-medium px-3 py-1 -mr-1 rounded-full">
          <%= @badge %>
        </span>
      <% end %>
    </.link>
    """
  end

  # You'll need to implement the `icon` component separately
  defp icon(assigns) do
    ~H"""
    <i class={"fa fa-#{@name}"} style={"color: #{@color}"}></i>
    """
  end
end
