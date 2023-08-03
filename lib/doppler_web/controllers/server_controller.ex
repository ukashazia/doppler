defmodule DopplerWeb.ServerController do
  use DopplerWeb, :controller

  def index(conn, _) do
    server_tags = Doppler.Servers.ServerTags.index()

    conn.params
    |> IO.inspect()

    servers =
      case conn.params do
        %{"name" => name, "page" => offset} ->
          %{
            server: Doppler.Servers.Server.index(String.to_integer(offset) * 10, name),
            server_count: Doppler.Servers.Server.server_count(name)
          }

        %{"name" => name} ->
          %{
            server: Doppler.Servers.Server.index(0, name),
            server_count: Doppler.Servers.Server.server_count(name)
          }

        %{"page" => offset} ->
          %{
            server: Doppler.Servers.Server.index(String.to_integer(offset) * 10),
            server_count: Doppler.Servers.Server.server_count()
          }

        %{} ->
          %{
            server: Doppler.Servers.Server.index(0),
            server_count: Doppler.Servers.Server.server_count()
          }
      end

    conn
    |> put_flash(:info, "load")
    |> render(:index,
      servers: servers.server,
      server_tags: server_tags,
      server_count: servers.server_count,
      layout: false
    )
  end

  def create(conn, server_params) do
    case Doppler.Servers.Server.add_server(server_params) do
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
    Doppler.Servers.Server.delete(server_id)

    conn
    |> put_flash(:success, "Server deleted successfully")
    |> redirect(to: "/servers")
  end
end
