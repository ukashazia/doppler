defmodule Doppler.Servers.Server do
  alias Doppler.{
    Schemas.Server,
    Schemas.ServerUsers,
    Schemas.ServerTags,
    Schemas.ServerPosts,
    Repo,
    Servers.ServerTags
  }

  import Ecto.Query

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

  def update_server(server_name, params) do
    {:ok, server} = get_server(server_name)
    server = server |> Repo.preload(:server_tags)
    server_tags = ServerTags.index(params["server_tags"])

    server
    |> Server.changeset(params)
    |> Ecto.Changeset.put_assoc(:server_tags, server_tags)
    |> Repo.update()
  end

  def index(offset, server_name, filters) do
    query = from(s in Server, order_by: [desc: s.inserted_at])

    query =
      query
      |> apply_search(server_name)
      |> apply_filters(filters)
      |> apply_pagination(offset)

    Repo.all(query)
    |> Repo.preload(:server_tags)
  end

  defp apply_pagination(query, offset) when not is_nil(offset) do
    offset =
      offset
      |> String.to_integer()
      |> Kernel.-(1)
      |> Kernel.*(10)

    # offset = String.to_integer(offset) * 10
    from(s in query, limit: 10, offset: ^offset)
  end

  defp apply_pagination(query, _), do: from(s in query, limit: 10, offset: 0)

  defp apply_filters(query, filters) when not is_nil(filters) do
    from(s in query,
      join: t in assoc(s, :server_tags),
      where: t.name in ^filters,
      distinct: s
    )
  end

  defp apply_filters(query, _), do: query

  defp apply_search(query, server_name) when not is_nil(server_name) do
    from(s in query, where: ilike(s.name, ^"%#{server_name}%"))
  end

  defp apply_search(query, _), do: query

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
    query =
      from(
        s in Server,
        join: u in assoc(s, :server_users),
        where: s.name == ^server_name,
        select: count(u)
      )

    [count] = Repo.all(query)
    count
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
  end

  def remove_server_user(user_name, server_name) do
    query =
      from(
        u in ServerUsers,
        join: s in assoc(u, :server),
        where: u.username == ^user_name and s.name == ^server_name,
        select: u
      )

    case Repo.all(query) do
      [] -> {:error, "No such user"}
      [user] -> Repo.delete(user)
    end
  end

  def list_server_posts(server_name) do
    query =
      from(
        p in ServerPosts,
        join: s in assoc(p, :server),
        where: s.name == ^server_name,
        select: p,
        order_by: [desc: p.inserted_at],
        preload: [:server_users]
      )

    case Repo.all(query) do
      [] -> []
      posts -> posts
    end
  end
end
