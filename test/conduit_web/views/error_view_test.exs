defmodule ConduitWeb.ErrorViewTest do
  use ConduitWeb.ConnCase, async: true

  test "renders 404.json" do
    assert render(ConduitWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Page not found"}}
  end

  test "renders 500.json" do
    assert render(ConduitWeb.ErrorView, "500.json", []) == %{errors: %{detail: "Internal server error"}}
  end

  # Define render/3
  defp render(view, template, assigns) do
    view.render(template, assigns)
  end
end
