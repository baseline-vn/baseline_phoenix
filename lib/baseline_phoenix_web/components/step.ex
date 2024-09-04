defmodule BaselinePhoenixWeb.Components.Step do
  use Phoenix.Component
  import Tails
  import BaselinePhoenixWeb.Components.Icon
  attr :title, :string, required: true

  attr :status, :string,
    values: ~w(current done upcoming),
    default: "current"

  attr :no, :integer, default: 0

  def step(assigns) do
    ~H"""
    <div class={
      classes([
        "flex flex-1 gap-4 h-16 border-b-4 items-center min-w-[240px]",
        [
          "border-primary-500": @status in ~w(current done)
        ]
      ])
    }>
      <div class={
        classes([
          "flex items-center justify-center w-9 h-9  rounded-full border-2",
          [
            "bg-primary-500 text-white": @status == "done",
            "border-primary-500 text-sm font-medium text-primary-500": @status == "current",
            "border-gray-300 text-sm font-medium text-gray-600": @status == "upcoming"
          ]
        ])
      }>
        <%= if @status == "done" do %>
          <.icon name="check" class="w-5 h-5" />
        <% else %>
          <%= @no |> Integer.to_string() |> String.pad_leading(2, "0") %>
        <% end %>
      </div>

      <div class="flex flex-col items-start">
        <div class={
          classes([
            "text-sm font-semibold",
            [
              "text-primary-500": @status in ~w(current done),
              "text-gray-600": @status == "upcoming"
            ]
          ])
        }>
          <%= @title %>
        </div>
      </div>
    </div>
    """
  end
end
