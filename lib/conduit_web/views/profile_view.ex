defmodule ConduitWeb.ProfileView do
  alias ConduitWeb.ProfileView

  def render("show.json", %{author: author}) do
    %{profile: render_one(author, ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{
      username: profile.username,
      bio: profile.bio,
      image: profile.image,
      following: profile.following
    }
  end

  # Define render_one/3
  defp render_one(data, view, template) do
    view.render(template, %{profile: data})
  end
end
