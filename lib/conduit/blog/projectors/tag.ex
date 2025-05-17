defmodule Conduit.Blog.Projectors.Tag do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    name: "Blog.Projectors.Tag",
    consistency: :eventual

  alias Conduit.Blog.Projections.Tag
  alias Conduit.Blog.Events.ArticlePublished

  project(%ArticlePublished{tag_list: tag_list}, fn multi ->
    Enum.reduce(tag_list, multi, fn tag, multi ->
      Ecto.Multi.insert(multi, "tag-#{tag}", %Tag{name: tag},
        on_conflict: :nothing,
        conflict_target: :name
      )
    end)
  end)
end
