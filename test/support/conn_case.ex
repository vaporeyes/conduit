defmodule ConduitWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest

      import ConduitWeb.ConnHelpers
      import ConduitWeb.Router.Helpers
      import Conduit.Factory
      import Conduit.Fixture

      # The default endpoint for testing
      @endpoint ConduitWeb.Endpoint
    end
  end

  setup _tags do
    Conduit.Storage.reset!()

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
