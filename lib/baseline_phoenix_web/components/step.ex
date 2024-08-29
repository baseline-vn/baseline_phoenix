defmodule BaselinePhoenixWeb.Components.Step do
  use Phoenix.Component
  attr :title, :string, required: true

  attr :status, :string,
    values: ~w(current done upcoming),
    default: "current"

  attr :no, :integer, default: 0

  def step(assigns) do
    ~H"""
    <div class={
      Tails.classes([
        "flex flex-1 gap-4 h-16 border-b-4 items-center min-w-[240px]",
        [
          "border-primary-500": @status in ~w(current done)
        ]
      ])
    }>
      <div class={
        Tails.classes([
          "flex items-center justify-center w-9 h-9  rounded-full border-2",
          [
            "bg-primary-500 text-white": @status == "done",
            "border-primary-500 text-sm font-medium text-primary-500": @status == "current",
            "border-gray-300 text-sm font-medium text-gray-600": @status == "upcoming"
          ]
        ])
      }>
        <%= if @status == "done" do %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
          </svg>
        <% else %>
          <%= @no |> Integer.to_string() |> String.pad_leading(2, "0") %>
        <% end %>
      </div>

      <div class="flex flex-col items-start">
        <div class={
          Tails.classes([
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
