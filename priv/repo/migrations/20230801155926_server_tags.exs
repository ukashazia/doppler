defmodule Doppler.Repo.Migrations.ServerTags do
  use Ecto.Migration

  def change do
    create table(:server_tags) do
      add :name, :string
      # add :server_id, references(:servers)
    end

    create unique_index(:server_tags, [:name])
  end
end
