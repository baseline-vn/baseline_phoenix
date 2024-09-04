defmodule BaselinePhoenixWeb.Components.Card.Story do
  use PhoenixStorybook.Story, :component

  def function, do: &BaselinePhoenixWeb.Components.Card.card/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          name: "Đỗ Tâm Hiền Dương",
          id: "76728364",
          rank: "635",
          avatar_url: "/path/to/avatar.jpg"
        }
      },
      %Variation{
        id: :without_rank,
        attributes: %{
          name: "John Doe",
          id: "12345678",
          rank: nil,
          avatar_url: "/path/to/default-avatar.jpg"
        }
      },
      %Variation{
        id: :long_name,
        attributes: %{
          name: "A Very Long Name That Might Wrap To Multiple Lines",
          id: "98765432",
          rank: "100",
          avatar_url: "/path/to/another-avatar.jpg"
        }
      }
    ]
  end
end
