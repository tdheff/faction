defmodule FactionWeb.API.V1.PlayerConrollerTest do
  use FactionWeb.ConnCase

  import Faction.GamesFixtures
  import Faction.UsersFixtures

  alias Faction.Games.Game
  alias Faction.Games.Player
  alias Faction.Users.User

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
    user = user_fixture()
    game = game_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user, game: game}
  end

  describe "index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player, game: game, user: user} do
      conn = get(conn, Routes.api_v1_game_player_path(conn, :index, game.id))
      assert [%{"nickname" => "some nickname", "user" => %{"id" => user.id, "name" => "test user"}}] == json_response(conn, 200)["data"]
    end
  end

  # describe "create player" do
  #   test "renders player when data is valid", %{conn: conn, game: game, , user: user} do
  #     conn = post(conn, Routes.api_v1_game_player_path(conn, :create), player: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = recycle_conn(conn)

  #     conn = get(conn, Routes.api_v1_game_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "adjudicate_on_weekends" => true,
  #              "adjudication_rate" => "day",
  #              "adjudication_time" => "14:00:00",
  #              "communication_type" => "always",
  #              "description" => "some description",
  #              "instant_adjudication" => true,
  #              "is_anonymous" => true,
  #              "is_private" => true,
  #              "name" => "some name"
  #            } = json_response(conn, 200)["data"]
  #   end
  # end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.api_v1_game_path(conn, :create), game: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete game" do
  #   setup [:create_player]

  #   test "deletes chosen game", %{conn: conn, game: game} do
  #     conn = delete(conn, Routes.api_v1_game_path(conn, :delete, game))
  #     assert response(conn, 204)

  #     conn = recycle_conn(conn)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.api_v1_game_path(conn, :show, game))
  #     end
  #   end
  # end

  defp create_player(%{user: user, game: game}) do
    player = player_fixture(user.id, game.id)
    %{player: player}
  end
end
