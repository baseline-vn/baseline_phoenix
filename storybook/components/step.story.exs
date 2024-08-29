defmodule Storybook.Component.Step do
  use PhoenixStorybook.Story, :component

  def function, do: &BaselinePhoenixWeb.Components.Step.step/1

  def variations do
    [
      %Variation{
        id: :done,
        attributes: %{
          title: "CHI TIẾT",
          no: 1,
          status: "done"
        }
      },
      %Variation{
        id: :current,
        attributes: %{
          title: "NỘI DUNG THI ĐẤU",
          no: 2,
          status: "current"
        }
      },
      %Variation{
        id: :upcoming,
        attributes: %{
          title: "BAN TỔ CHỨC",
          no: 3,
          status: "upcoming"
        }
      }
    ]
  end
end
