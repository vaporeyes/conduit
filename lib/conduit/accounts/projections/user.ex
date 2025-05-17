defmodule Conduit.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts_users" do
    field(:username, :string)
    field(:email, :string)
    field(:hashed_password, :string)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:username, :email, :hashed_password])
    |> Ecto.Changeset.unique_constraint(:username)
    |> Ecto.Changeset.unique_constraint(:email)
  end
end
