defmodule Doppler.Repo.Migrations.AlterPostBodyDataType do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      # this is done because 'string' data type allows max 255 characters
      modify :body, :text
    end
  end
end
