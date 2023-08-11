defmodule DopplerWeb.ServerUsersLive do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias Doppler.{Servers.Server, Servers.ServerTags, Repo, Users.User}
  alias Doppler.Schemas.Server, as: ServerSchema


  def mount(params, _session, socket) do
    server_name = Map.get(params, "name")

    server_user_count = Server.server_user_count(server_name)

    case Server.get_server_users(server_name) do
      {:ok, server} ->
        socket =
          socket
          |> assign(
            user_count: server_user_count,
            server: server,
            params: params,
            server_users: server.server_users
          )

        {:ok, socket}

      {:error} ->
        socket =
          socket
          |> push_redirect(to: "/servers")
          |> put_flash(:error, "Server not found !")

        {:ok, socket}
    end
  end

end
