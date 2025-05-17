defmodule ConduitWeb.TagView do
  alias ConduitWeb.TagView

  def render("index.json", %{tags: tags}) do
    %{tags: tags}
  end
end
