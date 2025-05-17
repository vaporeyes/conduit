defmodule ConduitWeb.ValidationView do

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
