defmodule Doppler.Schemas.ServerUsers do
  use Ecto.Schema
  import Ecto.Changeset
  alias Doppler.Schemas.{ServerUsers, Server}

  schema "server_users" do
    field :username, :string
    field :email, :string

    belongs_to :server, Server
  end

  def changeset(%ServerUsers{} = server_users, params \\ %{}) do
    server_users
    |> cast(params, [:username, :email])
    |> validate_required(:username)
    |> validate_required(:email)
    |> unique_constraint(:email, message: "Email already exists")
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/)
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
  end
end
