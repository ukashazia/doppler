defmodule DopplerWeb.ServerController do
  use DopplerWeb, :controller

  def index(conn, %{"name" => name}) do
    servers = Doppler.Servers.Server.index(0, name)
    server_count = Doppler.Servers.Server.server_count(name)

    conn
    |> put_flash(:info, "load")
    |> render(:index, servers: servers, server_count: server_count, layout: false)
  end

  def index(conn, _) do
    servers = Doppler.Servers.Server.index(0)
    server_count = Doppler.Servers.Server.server_count()

    conn
    |> put_flash(:info, "load")
    |> render(:index, servers: servers, server_count: server_count, layout: false)
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
