defmodule Doppler.Schemas.ServerTags do
  alias Doppler.Schemas.{Server, ServerTags}
  use Ecto.Schema
  import Ecto.Changeset

  schema "server_tags" do
    field :name, :string
    belongs_to :server, Server
  end

  def changeset(server_tags = %ServerTags{}, params \\ %{}) do
    server_tags
    |> cast(params, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
    |> validate_length(:name, less_than: 10)
  end
end
