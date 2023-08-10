defmodule Doppler.Servers.Server do
  alias Doppler.{Schemas.Server, Schemas.ServerTags, Repo}
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
end
