defmodule DopplerWeb.Live.ServerUsers.ServerUsersLive do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias Doppler.{Servers.Server}

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    server_name = assigns.server.name

    server_user_count = Server.server_user_count(server_name)

    case Server.get_server_users(server_name) do
      {:ok, server} ->
        socket =
          socket
          |> assign(
            user_count: server_user_count,
            server: server,
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

  def handle_event("add_server_user", _params, socket) do
    server_name = socket.assigns.server.name

    socket =
      socket
      |> push_navigate(to: "/servers/#{server_name}")

    {:noreply, socket}
  end
end
