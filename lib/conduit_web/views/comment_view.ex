defmodule ConduitWeb.CommentView do
  alias ConduitWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.uuid,
      body: comment.body,
      createdAt: NaiveDateTime.to_iso8601(comment.commented_at),
      updatedAt: NaiveDateTime.to_iso8601(comment.commented_at),
      author: %{
        username: comment.author_username,
        bio: comment.author_bio,
        image: comment.author_image,
        following: false
      }
    }
  end

  # Define render_many/3
  defp render_many(data, view, template) do
    Enum.map(data, fn item -> view.render(template, %{comment: item}) end)
  end

  # Define render_one/3
  defp render_one(data, view, template) do
    view.render(template, %{comment: data})
  end
end
