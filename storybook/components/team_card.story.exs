defmodule BaselinePhoenixWeb.Components.TeamCard.Story do
  use PhoenixStorybook.Story, :component

  def function, do: &BaselinePhoenixWeb.Components.TeamCard.team_card/1

  def variations do
    [
      %Variation{
        id: :Default,
        attributes: %{
          player1_avatar_url: "https://example.com/avatar1.jpg",
          player1_name: "Player One",
          player1_id: 12345,
          player1_rank: 100,
          player2_avatar_url: "https://example.com/avatar2.jpg",
          player2_name: "Player Two",
          player2_id: 67890,
          player2_rank: 200,
          status_draw: false,
          verified_rank: false,
          branch: "Nhánh 1"
        }
      },
      %Variation{
        id: :Draw_done,
        attributes: %{
          player1_avatar_url: "https://example.com/avatar1.jpg",
          player1_name: "Player One",
          player1_id: 12345,
          player1_rank: 100,
          player2_avatar_url: "https://example.com/avatar2.jpg",
          player2_name: "Player Two",
          player2_id: 67890,
          player2_rank: 200,
          status_draw: false,
          verified_rank: false,
          branch: "Nhánh 1"
        }
      },
      %Variation{
        id: :Verified_rank,
        attributes: %{
          player1_avatar_url: "https://example.com/avatar1.jpg",
          player1_name: "Player One",
          player1_id: 12345,
          player1_rank: 100,
          player2_avatar_url: "https://example.com/avatar2.jpg",
          player2_name: "Player Two",
          player2_id: 67890,
          player2_rank: 200,
          status_draw: true,
          verified_rank: true,
          branch: "Nhánh 1"
        }
      }
    ]
  end
end
