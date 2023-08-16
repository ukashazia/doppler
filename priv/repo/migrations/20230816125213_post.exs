defmodule Doppler.Repo.Migrations.Post do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string
      add :created_at, :utc_datetime
      add :user_id, references(:server_users)
      add :server_id, references(:servers)
      timestamps()
    end
  end
end
