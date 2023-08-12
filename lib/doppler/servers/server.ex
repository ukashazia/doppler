defmodule Doppler.Servers.Server do
  alias Doppler.Servers
  alias Doppler.{Schemas.Server, Schemas.ServerUsers, Schemas.ServerTags, Repo, Users.User}
  import Ecto.Query
  # alias Doppler.Servers.ServerTags

  def add_server(server_params) do
    tag =
      if tagid = Map.get(server_params, "server_tags") do
        Enum.map(tagid, fn x ->
          Repo.get(ServerTags, x)
        end)
      else
        []
      end

    Server.changeset(%Server{}, server_params)
    |> Ecto.Changeset.put_assoc(:server_tags, tag)
    |> IO.inspect()
    |> Repo.insert()
  end

  def index(offset) do
    from(s in Server, limit: 10, offset: ^offset)
    |> Repo.all()
    |> Repo.preload(:server_tags)
  end

  def index(offset, server_name) do
    from(s in Server,
      limit: 10,
      where: ilike(s.name, ^"%#{server_name}%"),
      offset: ^offset
    )
    |> Repo.all()
    |> Repo.preload(:server_tags)
  end

  def delete(server_id) do
    Repo.get(Server, server_id)
    |> Repo.delete()
  end

  def server_count() do
    query = from(s in Server, select: count())
    # pattern m atching cuz server_ocunt returns number in a list
    [count] = Repo.all(query)
    count
  end

  def server_count(name) do
    query =
      from(s in Server,
        where: ilike(s.name, ^"%#{name}%"),
        select: count()
      )

    # pattern m atching cuz server_ocunt returns number in a list
    [count] = Repo.all(query)
    count
  end

  def get_server(name) do
    case server = Repo.get_by(Server, %{name: name}) |> Repo.preload(:server_tags) do
      %Server{} -> {:ok, server}
      nil -> {:error}
    end
  end

  def get_server_users(name) do
    case server = Repo.get_by(Server, %{name: name}) |> Repo.preload(:server_users) do
      %Server{} -> {:ok, server}
      nil -> {:error}
    end
  end

  def server_user_count(server_name) do
    # query = from(s in Server,
    #  preload: [:server_users],
    #  select: count(s.server_users),
    #  )
    server = Repo.get_by(Server, %{name: server_name}) |> Repo.preload(:server_users)
    length(server.server_users)
    # pattern m atching cuz server_ocunt returns number in a list
    # [count] = Repo.all(query)
    # count
  end

  def server_user_count(server_name, user_name) do
    query =
      from(s in Server,
        preload: [:server_users],
        where: ilike(s.user_name, ^"%#{user_name}%"),
        where: ilike(s.server_name, ^"%#{server_name}%"),
        select: count(s.server_users)
      )

    # pattern m atching cuz server_ocunt returns number in a list
    [count] = Repo.all(query)
    count
  end

  def add_user(server_name, user_params) do
    IO.inspect(user_params)
    server = Repo.get_by(Server, %{name: server_name}) |> Repo.preload(:server_users)
    # user_changeset = ServerUsers.changeset(%ServerUsers{}, user_params)
    # server_changeset = Ecto.Changeset.change(server)
    # |> Ecto.Changeset.put_assoc(:server_users, [user_changeset])
    # |> Repo.update()

    # user = Ecto.build_assoc(server, :server_users, user_params)
    # Repo.insert(user)

    user_changeset =
      ServerUsers.changeset(%ServerUsers{}, user_params)
      |> Ecto.Changeset.put_assoc(:server, server)
      |> IO.inspect()

    case Repo.insert(user_changeset) do
      {:ok, user} ->
        IO.inspect(user)
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end

    # case User.add_user(user_params) do
    #   {:ok, user} ->
    #     IO.inspect(user)

    #     server
    #     |> IO.inspect()
    #     |> Ecto.Changeset.change()
    #     |> IO.inspect()
    #     |> Ecto.build_assoc(:server_users, [user])
    #     |> Repo.update()

    #     {:ok, user}

    #   {:error, changeset} ->
    #     {:error, changeset}
    # end
  end
end
