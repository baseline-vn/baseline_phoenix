defmodule BaselinePhoenixWeb.Step do
  use Phoenix.Component
  attr :title, :string, required: true

  attr :status, :string,
    values: ~w(current done upcoming),
    default: "current"

  attr :no, :integer, default: 0

  def step(assigns) do
    ~H"""
    <div class="flex items-center">
      <div class="flex items-center justify-center w-10 h-10 bg-green-500 text-white rounded-full">
        <%= @no %>
      </div>
      <div class={
        Tails.classes([
          "ml-2 text-green-500 font-bold",
          @status == "upcoming" && "bg-red-900",
          @status == "done" && "bg-green-900"
        ])
      }>
        <%= @status %>
      </div>
    </div>
    <div class="flex-1 h-1 bg-green-500"></div>

    <%= @title %>
    <%= @status %>
    <%= @no %>
    """
  end
end
