defmodule ConduitWeb.UserView do
  alias ConduitWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: jwt}) do
    %{user: user |> render_one(UserView, "user.json") |> Map.merge(%{token: jwt})}
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      bio: nil,
      image: nil
    }
  end

  # Define render_many/3
  defp render_many(data, view, template) do
    Enum.map(data, fn item -> view.render(template, %{user: item}) end)
  end

  # Define render_one/3
  defp render_one(data, view, template) do
    view.render(template, %{user: data})
  end
end
