defmodule Doppler.Repo.Migrations.ServersManyToManyUsers do
  use Ecto.Migration

  def change do
    create table(:servers_many_to_many_users) do
      add :server_id, references(:servers)
      add :server_users_id, references(:server_users)
    end

    create unique_index(:servers_many_to_many_users, [:server_id, :server_users_id])
  end
end
