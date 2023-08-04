defmodule DopplerWeb.ServerController do
  use DopplerWeb, :controller
  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema

  def index(conn, _) do
    server_tags = ServerTags.index()
    changeset = ServerSchema.changeset(%ServerSchema{} |> Repo.preload(:server_tags))
    IO.inspect(%ServerSchema{} |> Repo.preload(:server_tags))

    servers =
      case conn.params do
        %{"name" => name, "page" => offset} ->
          %{
            server: Server.index(String.to_integer(offset) * 10, name),
            server_count: Server.server_count(name)
          }

        %{"name" => name} ->
          %{
            server: Server.index(0, name),
            server_count: Server.server_count(name)
          }

        %{"page" => offset} ->
          %{
            server: Server.index(String.to_integer(offset) * 10),
            server_count: Server.server_count()
          }

        %{} ->
          %{
            server: Server.index(0),
            server_count: Server.server_count()
          }
      end

    conn
    |> put_flash(:info, "load")
    |> render(:index,
      servers: servers.server,
      server_tags: server_tags,
      server_count: servers.server_count,
      changeset: changeset,
      layout: false
    )
  end

  def create(conn, server_params) do
    case Server.add_server(server_params) do
      {:ok, _server} ->
        conn
        |> redirect(to: "/servers")
        |> put_flash(:info, "Server created successfully.")

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Something went wrong.")
        |> redirect(to: "/servers")
    end
  end

  def delete(conn, %{"server" => server_id}) do
    Server.delete(server_id)

    conn
    |> put_flash(:success, "Server deleted successfully")
    |> redirect(to: "/servers")
  end
end
