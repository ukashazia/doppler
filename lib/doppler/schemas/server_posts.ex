defmodule Doppler.Schemas.ServerPosts do
  use Ecto.Schema
  import Ecto.Changeset
  alias Doppler.Schemas.ServerPosts

  schema "posts" do
    field :title, :string
    field :body, :string
    field :created_at, :utc_datetime

    belongs_to :server, Doppler.Schemas.Server
    belongs_to :server_users, Doppler.Schemas.ServerUsers
    timestamps()
  end

  def changeset(post = %ServerPosts{}, attrs) do
    post
    |> cast(attrs, [:title, :body])
    # |> cast_assoc(:server)
    # |> cast_assoc(:server_users)
    |> validate_required([:title, :body])
    |> validate_length(:title, min: 5, max: 50)
    |> validate_length(:body, min: 5, max: 4000)
  end
end
