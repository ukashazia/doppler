defmodule Doppler.Schemas.ServerPosts do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :created_at, :utc_datetime

    belongs_to :server, Doppler.Schemas.Server
    belongs_to :server_users, Doppler.Schemas.ServerUsers
    timestamps()
  end
end
