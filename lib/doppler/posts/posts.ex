defmodule Doppler.Posts.Posts do
  alias Doppler.{Schemas.ServerPosts, Repo}
  import Ecto.Query

  def get_posts(user_name, server_name) do
    query =
      from(
        p in Doppler.Schemas.ServerPosts,
        join: u in assoc(p, :server_users),
        join: s in assoc(p, :server),
        where: u.username == ^user_name and s.name == ^server_name
      )

    Repo.all(query)
    |> Repo.preload(:server_users)
  end

  def add_post(server_name, user_name, post_params) do
    {:ok, server} = Doppler.Servers.Server.get_server(server_name)
    server = Repo.preload(server, :post)
    {:ok, user} = Doppler.Users.User.get_user(user_name, server_name)
    user = Repo.preload(user, :post)
    IO.inspect(server)
    IO.inspect(user)

    post_changeset =
      ServerPosts.changeset(%ServerPosts{}, post_params)
      |> Ecto.Changeset.put_assoc(:server, server)
      |> Ecto.Changeset.put_assoc(:server_users, user)
      |> IO.inspect()

    case Repo.insert(post_changeset) do
      {:ok, post} ->
        IO.inspect(post)
        {:ok, post}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def post_count(user_name, server_name) do
    query =
      from(p in ServerPosts,
        where: ilike(p.user_name, ^"%#{user_name}%"),
        where: ilike(p.server_name, ^"%#{server_name}%"),
        select: count()
      )

    # pattern m atching cuz server_ocunt returns number in a list
    [count] = Repo.all(query)
    count
  end

  def get_post(user_name, server_name, post_id) do
    query =
      from(
        p in Doppler.Schemas.ServerPosts,
        join: u in assoc(p, :user),
        join: s in assoc(u, :server),
        where: u.username == ^user_name and s.name == ^server_name and p.id == ^post_id
      )

    Repo.one(query)
    |> Repo.preload(:user)
  end

  def delete_post(user_name, server_name, post_id) do
    query =
      from(
        p in Doppler.Schemas.ServerPosts,
        join: u in assoc(p, :user),
        join: s in assoc(u, :server),
        where: u.username == ^user_name and s.name == ^server_name and p.id == ^post_id
      )

    Repo.delete(query)
  end

  # def update_post(post_params) do
  #   post_changeset = ServerPosts.changeset(%ServerPosts{}, post_params)

  #   case Repo.update(post_changeset) do
  #     {:ok, post} ->
  #       IO.inspect(post)
  #       {:ok, post}
end
