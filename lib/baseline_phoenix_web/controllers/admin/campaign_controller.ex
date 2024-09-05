defmodule BaselinePhoenixWeb.Admin.CampaignController do
  use BaselinePhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
