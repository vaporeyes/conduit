defmodule ConduitWeb.ArticleView do
  alias ConduitWeb.ArticleView

  def render("index.json", %{articles: articles, total_count: total_count}) do
    %{
      articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: total_count
    }
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: article.tag_list,
      createdAt: NaiveDateTime.to_iso8601(article.published_at),
      updatedAt: NaiveDateTime.to_iso8601(article.updated_at),
      favoritesCount: article.favorite_count,
      favorited: article.favorited,
      author: %{
        username: article.author_username,
        bio: article.author_bio,
        image: article.author_image,
        following: false
      }
    }
  end

  # Define render_many/3
  defp render_many(data, view, template) do
    Enum.map(data, fn item -> view.render(template, %{article: item}) end)
  end

  # Define render_one/3
  defp render_one(data, view, template) do
    view.render(template, %{article: data})
  end
end
