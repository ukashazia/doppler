defmodule Doppler.Repo.Migrations.ServerUsers do
  use Ecto.Migration

  def change do
    create table(:server_users) do
      add :username, :string
      add :email, :string
    end

    create unique_index(:server_users, [:username, :email])
  end
end
