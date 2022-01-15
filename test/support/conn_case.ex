defmodule FactionWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use FactionWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  @pow_config [otp_app: :faction]

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import FactionWeb.ConnCase

      alias FactionWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint FactionWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Faction.Repo, shared: not tags[:async])
    # create_test_user()
    conn = Phoenix.ConnTest.build_conn()
    authed_conn = Pow.Plug.assign_current_user(conn, %Faction.Users.User{email: "test@example.com", id: 1}, @pow_config)
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  def recycle_conn(conn) do
    assigns = conn.assigns
    conn
    |> Phoenix.ConnTest.recycle()
    |> Map.put(:assigns, assigns)
  end
end
