defmodule Doppler.Users.User do
  alias Doppler.{Schemas.Server, Repo, Schemas.ServerUsers}
  import Ecto.Query

  def user_count(user_name, server_name) do
    query =
      from(s in Server,
        where: ilike(s.user_name, ^"%#{user_name}%"),
        where: ilike(s.server_name, ^"%#{server_name}%"),
        select: count()
      )

    # pattern m atching cuz server_ocunt returns number in a list
    [count] = Repo.all(query)
    count
  end

  def add_user(user_params) do
    user_changeset = ServerUsers.changeset(%ServerUsers{}, user_params)

    case Repo.insert(user_changeset) do
      {:ok, user} ->
        IO.inspect(user)
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
