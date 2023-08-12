defmodule DopplerWeb.ServerShowLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
  # use Phoenix.Component
  alias Phoenix.LiveView.JS
  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema

  def mount(params, _session, socket) do
    server_name = Map.get(params, "name")

    case Server.get_server(server_name) do
      {:ok, server} ->
        socket =
          socket
          |> assign(
            server: server,
            params: params
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

  def handle_params(params, url, socket) do
    {:noreply, socket}
  end

  def handle_event("delete_server", _params, socket) do
    server_id = socket.assigns.server.id

    Server.delete(server_id)

    socket =
      socket
      |> push_navigate(to: "/servers")
      |> put_flash(:info, "Server deleted !")

    {:noreply, socket}
  end

  def handle_event("add_server_user", params, socket) do
    server_name = socket.assigns.server.name

    socket =
      socket
      |> assign(server: socket.assigns.server)
      |> push_navigate(to: "/servers/#{server_name}/users/create")

    {:noreply, socket}
  end

  def redirect(socket, params) do
    server_name = Map.get(params, "name")

    socket =
      socket
      |> push_navigate(to: "/servers/#{server_name}/info")
      |> assign(params: params)

    {:noreply, socket}
  end
end