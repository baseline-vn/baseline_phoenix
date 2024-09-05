defmodule BaselinePhoenixWeb.LayoutComponents do
  use Phoenix.Component
  import Phoenix.Component

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
            Log out
          </.link>
        </li>
      <% else %>
        <li>
          <.link
            href="/sign_in"
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Sign in
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end
end
