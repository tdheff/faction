defmodule FactionWeb.API.V1.GameControllerTest do
  use FactionWeb.ConnCase

  import Faction.GamesFixtures

  alias Faction.Games.Game

  @create_attrs %{
    adjudicate_on_weekends: true,
    adjudication_rate: "day",
    adjudication_time: ~T[14:00:00],
    communication_type: "always",
    description: "some description",
    instant_adjudication: true,
    is_anonymous: true,
    is_private: true,
    name: "some name"
  }
  @update_attrs %{
    adjudicate_on_weekends: false,
    adjudication_rate: "hour",
    adjudication_time: ~T[15:01:01],
    communication_type: "none",
    description: "some updated description",
    instant_adjudication: false,
    is_anonymous: false,
    is_private: false,
    name: "some updated name"
  }
  @invalid_attrs %{adjudicate_on_weekends: nil, adjudication_rate: nil, adjudication_time: nil, communication_type: nil, description: nil, instant_adjudication: nil, is_anonymous: nil, is_private: nil, name: nil}

  setup %{authed_conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all games", %{authed_conn: conn} do
      conn = get(conn, Routes.api_v1_game_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{authed_conn: conn} do
      conn = post(conn, Routes.api_v1_game_path(conn, :create), game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = recycle_conn(conn)

      conn = get(conn, Routes.api_v1_game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "adjudicate_on_weekends" => true,
               "adjudication_rate" => "day",
               "adjudication_time" => "14:00:00",
               "communication_type" => "always",
               "description" => "some description",
               "instant_adjudication" => true,
               "is_anonymous" => true,
               "is_private" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: conn} do
      conn = post(conn, Routes.api_v1_game_path(conn, :create), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{authed_conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, Routes.api_v1_game_path(conn, :update, game), game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = recycle_conn(conn)

      conn = get(conn, Routes.api_v1_game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "adjudicate_on_weekends" => false,
               "adjudication_rate" => "hour",
               "adjudication_time" => "15:01:01",
               "communication_type" => "none",
               "description" => "some updated description",
               "instant_adjudication" => false,
               "is_anonymous" => false,
               "is_private" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: conn, game: game} do
      conn = put(conn, Routes.api_v1_game_path(conn, :update, game), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{authed_conn: conn, game: game} do
      conn = delete(conn, Routes.api_v1_game_path(conn, :delete, game))
      assert response(conn, 204)

      conn = recycle_conn(conn)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_game_path(conn, :show, game))
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
