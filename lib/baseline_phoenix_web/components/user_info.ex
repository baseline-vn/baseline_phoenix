defmodule BaselinePhoenixWeb.Components.UserInfo do
  @moduledoc """
  User info component
  """
  use Phoenix.Component
  import BaselinePhoenixWeb.Gettext

  attr :current_user, :map, required: true

  def user_info(assigns) do
    ~H"""
    <div class="border-t border-gray-200 py-4 mx-4 ">
      <%= if @current_user do %>
        <.link href="/me" class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold flex-1">
          <div class="flex items-center gap-2">
            <div class="flex items-center gap-2">
              <img
                src={
                  BaselinePhoenix.AvatarUploader.url({@current_user.avatar, @current_user}, :thumb)
                }
                alt="Avatar"
                class="w-10 h-10 p-1 rounded-full border border-gray-100"
              />
              <div>
                <p class="text-t-md">
                  <%= @current_user.full_name || @current_user.email || @current_user.phone_number %>
                </p>
                <p class="text-t-sm">
                  ID: <%= @current_user.vtid %>
                </p>
              </div>
            </div>
            <div class="flex items-center justify-center w-8 h-8 ml-auto p-1 rounded-full hover:bg-gray-100 hover:cursor-pointer">
              <.link
                href="/log_out"
                method="delete"
                class="flex items-center justify-center w-full h-full"
              >
                <img
                  src="/icons/arrow-up-from-bracket-solid.svg"
                  alt="Log out"
                  class="w-5 h-5 inline-block rotate-90"
                />
              </.link>
            </div>
          </div>
        </.link>
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
      <% else %>
        <.link
          href="/sign_in"
          class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
        >
          <%= gettext("Sign in") %>
        </.link>
      <% end %>
    </div>
    """
  end
end
