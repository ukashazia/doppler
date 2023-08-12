defmodule Doppler.Repo.Migrations.ServerUsers do
  use Ecto.Migration

  def change do
    create table(:server_users) do
      add :username, :string
      add :email, :string
      add :server_id, references(:servers)
    end

    create unique_index(:server_users, [:username])
    create unique_index(:server_users, [:email])
  end
end
