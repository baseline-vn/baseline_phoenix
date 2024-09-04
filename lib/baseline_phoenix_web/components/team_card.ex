defmodule BaselinePhoenixWeb.Components.TeamCard do
  use Phoenix.Component
  import BaselinePhoenixWeb.Components.Icon
  import Tails
  # Player 1 attributes
  attr :player1_avatar_url, :string, required: true
  attr :player1_name, :string, required: true
  attr :player1_id, :integer, required: true
  attr :player1_rank, :integer, required: true

  # Player 2 attributes
  attr :player2_avatar_url, :string, required: true
  attr :player2_name, :string, required: true
  attr :player2_id, :integer, required: true
  attr :player2_rank, :integer, required: true

  attr :status_draw, :boolean, default: false
  attr :verified_rank, :boolean, default: false
  attr :branch, :string, required: true

  def team_card(assigns) do
    ~H"""
    <div class="block max-w-sm min-w-[396px] min-h-[216px] bg-white border border-gray-300 rounded">
      <div class="flex items-start justify-between px-4 py-2 border-b-2">
        <div class="flex gap-2 items-center">
          <span class={
            classes([
              "p-1 w-7 h-7 rounded-2xl",
              [
                "bg-error-100 fill-error-600": @status_draw == false,
                "bg-primary-100 fill-primary-600": @status_draw == true
              ]
            ])
          }>
            <div class="flex justify-center">
              <.icon name="vector" class="-rotate-90 w-[16.67px] h-[16.67px]" />
            </div>
          </span>
          <span class={
            classes([
              " px-3 py-1 rounded-2xl flex gap-[5.67px] text-sm font-medium",
              [
                "bg-error-100  fill-error-600 text-error-600": @verified_rank == false,
                "bg-primary-100 fill-primary-600 text-primary-600": @verified_rank == true
              ]
            ])
          }>
            <div class="flex justify-center ">
              <.icon name="ranking" class="w-5 h-5" />
            </div>
            <%= @player1_rank + @player2_rank %>
          </span>
          <span class="bg-blue-100 px-3 py-1 rounded-2xl flex items-center gap-1 text-sm font-medium text-blue-600">
            <.icon name="branch" class="fill-blue-600 " />
            <%= @branch %>
          </span>
        </div>

        <div class="relative">
          <button
            id="dropdownMenuButton"
            class="dropdown-toggle inline-block text-gray-500 hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-200 rounded-lg text-sm p-1.5"
            type="button"
            aria-haspopup="true"
            aria-expanded="false"
          >
            <span class="sr-only">Open dropdown</span>
            <.icon name="ellipsis-horizontal" class="" />
          </button>
          <!-- Dropdown menu -->
        </div>
      </div>

      <div class="flex flex-col px-5 py-3">
        <div class="flex items-center mb-3">
          <img
            class="w-12 h-12 rounded-full mr-3"
            src="https://flowbite.com/docs/images/people/profile-picture-3.jpg"
            alt=""
          />
          <div class="">
            <h3 class="text-md font-medium"><%= @player1_name %></h3>
            <div class=" text-gray-700 flex text-sm font-medium gap-1 mt-2">
              <span class="bg-gray-100 rounded-2xl px-3 flex items-center gap-1">
                <.icon name="verify" class="w-[16.48px] h-[16.48px]" />
                <%= @player1_id %>
              </span>
              <span class=" bg-gray-100 rounded-2xl px-3 py-1 ml-2">
                <%= @player1_rank %>
              </span>
            </div>
          </div>
        </div>
        <div class="flex items-center mt-4">
          <img
            class="w-12 h-12 rounded-full mr-3"
            src="https://flowbite.com/docs/images/people/profile-picture-4.jpg"
            alt=""
          />
          <div class="">
            <h3 class="text-md font-medium"><%= @player2_name %></h3>
            <div class=" text-gray-700 flex text-sm font-medium gap-1 mt-2">
              <span class="bg-gray-100 rounded-2xl px-3 flex items-center gap-1">
                <.icon name="verify" class="w-[16.48px] h-[16.48px]" />
                <%= @player2_id %>
              </span>
              <span class=" bg-gray-100 rounded-2xl px-3 py-1 ml-2">
                <%= @player2_rank %>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <%!-- <%= @avatar_url %>
    <%= @name %>
    <%= @id %>
    <%= @rank %>
    <%= @verfied %> --%>
    """
  end
end
