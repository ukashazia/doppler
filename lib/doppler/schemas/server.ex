defmodule Doppler.Schemas.Server do
  alias Doppler.Schemas.{Server, ServerTags, ServerUsers, ServerPosts}
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :name, :string
    field :description, :string

    many_to_many :server_tags, ServerTags,
      join_through: "servers_many_to_many_tags",
      on_delete: :delete_all,
      on_replace: :delete

    has_many :server_users, ServerUsers, on_delete: :delete_all
    has_many :post, ServerPosts, on_delete: :delete_all
    timestamps()
  end

  def changeset(server = %Server{}, params \\ %{}) do
    server
    |> cast(params, [:name, :description])
    # |> cast_assoc(:server_tags)
    # |> cast_assoc(:server_users)
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]+$/)
    |> validate_length(:name, less_than: 20, greater_than: 2)
    |> validate_length(:description, less_than: 100, greater_than: 2)
  end
end
