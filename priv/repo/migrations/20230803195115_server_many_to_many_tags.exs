defmodule Doppler.Repo.Migrations.ServerManyToManyTags do
  use Ecto.Migration

  def change do
    create table(:servers_many_to_many_tags) do
      add :server_id, references(:servers)
      add :server_tags_id, references(:server_tags)
    end

    create unique_index(:servers_many_to_many_tags, [:server_id, :server_tags_id])
  end
end
