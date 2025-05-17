defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.{Accounts, Blog}

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [
      user: user
    ]
  end

  def create_author(%{user: user}) do
    {:ok, author} = fixture(:author, user_uuid: user.uuid)

    [
      author: author
    ]
  end

  def create_author(_context) do
    {:ok, author} = fixture(:author, user_uuid: UUID.uuid4())

    [
      author: author
    ]
  end

  def create_author_to_follow(_context) do
    {:ok, author} = fixture(:author, user_uuid: UUID.uuid4(), username: "jane")

    [
      author_to_follow: author
    ]
  end

  def follow_author(%{author_to_follow: author, author: follower}) do
    {:ok, _author} = Blog.follow_author(author, follower)

    []
  end

  def publish_article(%{author: author}) do
    {:ok, article} = fixture(:article, author: author)

    [
      article: article
    ]
  end

  def publish_articles(%{author: author}) do
    {:ok, article1} =
      fixture(:article, author: author, tag_list: ["dragons", "training", "believe"])

    {:ok, article2} =
      fixture(:article,
        author: author,
        title: "How to train your dragon 2",
        description: "So toothless",
        body: "It a dragon"
      )

    [
      articles: [article1, article2]
    ]
  end

  def get_author(%{user: user}) do
    author = Blog.get_author!(user.uuid)

    [
      author: author
    ]
  end

  def favorite_article(%{articles: [article | articles], author: author}) do
    {:ok, article} = Blog.favorite_article(article, author)

    [
      articles: [article | articles]
    ]
  end

  def favorite_article(%{article: article, author: author}) do
    {:ok, article} = Blog.favorite_article(article, author)

    [
      article: article
    ]
  end

  def comment_on_article(%{article: article, author: author}) do
    {:ok, comment} = fixture(:comment, article: article, author: author)

    [
      comment: comment
    ]
  end

  def fixture(resource, attrs \\ [])

  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def fixture(:article, attrs) do
    {author, attrs} = Keyword.pop(attrs, :author)

    Blog.publish_article(author, build(:article, attrs))
  end

  def fixture(:comment, attrs) do
    {article, attrs} = Keyword.pop(attrs, :article)
    {author, attrs} = Keyword.pop(attrs, :author)

    Blog.comment_on_article(article, author, build(:comment, attrs))
  end
end
