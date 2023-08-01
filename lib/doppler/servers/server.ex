defmodule Doppler.Servers.Server do
  alias Doppler.{Schemas.Server, Repo}
  import Ecto.Query

  def add_server(params) do
    Server.changeset(%Server{}, params)
    |> Repo.insert()
  end

  def index(offset) do
    from(s in Server, limit: 10, offset: ^offset)
    |> Repo.all()
  end

  def index(offset, server_name) do
    from(s in Server,
      limit: 10,
      where: ilike(s.name, ^"%#{server_name}%"),
      offset: ^offset
    )
    |> Repo.all()
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
