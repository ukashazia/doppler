defmodule Doppler.Repo.Migrations.Servers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :description, :string
      timestamps()
    end

    create unique_index(:servers, [:name])
  end
end
