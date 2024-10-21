defmodule BaselinePhoenixWeb.Components.Card do
  use Phoenix.Component
  attr :avatar_url, :string, required: true
  attr :name, :string, required: true
  attr :id, :integer, required: true
  attr :rank, :integer, required: true
  attr :verfied, :boolean, default: false
  attr :branch, :string, required: true

  def card(assigns) do
    ~H"""
    <div class="block max-w-sm  bg-white border border-gray-300 rounded">
      <div class="flex items-start justify-between px-4 py-2 border-b-2">
        <div class="flex gap-2">
          <span class="bg-error-100 p-1 rounded-2xl w-7 h-7 ">
            icon
          </span>
          <span class="bg-error-100 px-3 py-1 rounded-2xl">
            icon <%= @rank %>
          </span>
          <span class="bg-blue-100 px-3 py-1 rounded-2xl">
            icon <%= @branch %>
          </span>
        </div>

        <div class="relative">
          <button
            id="dropdownButton"
            data-dropdown-toggle="dropdown"
            class="inline-block text-gray-500 hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-200 rounded-lg text-sm p-1.5"
            type="button"
          >
            <span class="sr-only">Open dropdown</span>
            <svg
              class="w-5 h-5"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 3"
            >
              <path d="M2 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3Zm6.041 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM14 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3Z" />
            </svg>
          </button>
          <!-- Dropdown menu -->
          <div
            id="dropdown"
            class="z-10 hidden text-base list-none bg-white divide-y divide-gray-100 rounded-lg shadow w-44"
          >
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="dropdownButton">
              <li>
                <a href="#" class="block px-4 py-2 hover:bg-gray-100">Edit</a>
              </li>
              <li>
                <a href="#" class="block px-4 py-2 hover:bg-gray-100">Delete</a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <div class="flex flex-col px-5 py-3">
        <div class="flex items-center mb-3">
          <img
            class="w-12 h-12 rounded-full mr-3"
            src="https://flowbite.com/docs/images/people/profile-picture-3.jpg"
            alt=""
          />
          <div class="font-medium">
            <h3 class=""><%= @name %></h3>
            <div class="mt-1  text-gray-700">
              <span class="bg-gray-100 rounded-2xl px-3 ">
                icon <%= @id %>
              </span>
              <span class=" bg-gray-100 rounded-2xl px-3 py-1 ml-2">
                <%= @rank %>
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
            <h3 class="font-medium"><%= @name %></h3>
            <div class="mt-1  text-gray-700">
              <span class="bg-gray-100 rounded-2xl px-3 text-xs">
                icon <%= @id %>
              </span>
              <span class=" bg-gray-100 rounded-2xl px-3 py-1 ml-2">
                <%= @rank %>
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
