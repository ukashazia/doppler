defmodule Doppler.Schemas.Server do
  alias Doppler.Schemas.Server
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :name, :string
    field :description, :string
  end

  def changeset(server = %Server{}, params) do
    server
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]+$/)
    |> validate_length(:name, less_than: 20, greater_than: 2)
    |> validate_length(:description, less_than: 100, greater_than: 2)
  end
end
