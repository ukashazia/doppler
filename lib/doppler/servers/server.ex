defmodule Doppler.Servers.Server do
  alias Doppler.{Schemas.Server, Schemas.ServerTags, Repo}
  import Ecto.Query

  def add_server(params) do
    %{"server" => %{"server_tags" => tagid}} = params
    tagid = Enum.map(tagid, &String.to_integer/1)
    tag = Enum.map(tagid, &Repo.get(ServerTags, &1))
    IO.inspect(params)

    Server.changeset(%Server{}, params)
    |> Ecto.Changeset.change(%{server_tags: tag})
    |> IO.inspect()
    |> Repo.insert()

    # IO.inspect(params)
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
end
