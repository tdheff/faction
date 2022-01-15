defmodule FactionWeb.GameControllerTest do
  use FactionWeb.ConnCase

  import Faction.GamesFixtures

  @create_attrs %{adjudicate_on_weekends: true, adjudication_rate: "day", adjudication_time: ~T[14:00:00], communication_type: "always", description: "some description", instant_adjudication: true, is_anonymous: true, is_private: true, name: "some name"}
  @update_attrs %{adjudicate_on_weekends: false, adjudication_rate: "hour", adjudication_time: ~T[15:01:01], communication_type: "none", description: "some updated description", instant_adjudication: false, is_anonymous: false, is_private: false, name: "some updated name"}
  @invalid_attrs %{adjudicate_on_weekends: nil, adjudication_rate: nil, adjudication_time: nil, communication_type: nil, description: nil, instant_adjudication: nil, is_anonymous: nil, is_private: nil, name: nil}

  # setup [:log_in]

  describe "index" do
    test "lists all games", %{authed_conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "new game" do
    test "renders form", %{authed_conn: conn} do
      conn = get(conn, Routes.game_path(conn, :new))
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "create game" do
    test "redirects to show when data is valid", %{authed_conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_path(conn, :show, id)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.game_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Game"
    end

    test "renders errors when data is invalid", %{authed_conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "edit game" do
    setup [:create_game]

    test "renders form for editing chosen game", %{authed_conn: conn, game: game} do
      conn = get(conn, Routes.game_path(conn, :edit, game))
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "update game" do
    setup [:create_game]

    test "redirects when data is valid", %{authed_conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @update_attrs)
      assert redirected_to(conn) == Routes.game_path(conn, :show, game)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.game_path(conn, :show, game))
      assert html_response(conn, 200) =~ "hour"
    end

    test "renders errors when data is invalid", %{authed_conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{authed_conn: conn, game: game} do
      conn = delete(conn, Routes.game_path(conn, :delete, game))
      assert redirected_to(conn) == Routes.game_path(conn, :index)

      conn = recycle_conn(conn)

      assert_error_sent 404, fn ->
        get(conn, Routes.game_path(conn, :show, game))
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
