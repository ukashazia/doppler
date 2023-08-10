defmodule DopplerWeb.ServerShowLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
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

  def handle_params(unsigned_params, uri, socket) do
    {:noreply, socket}
  end

  def handle_event("delete_server", params, socket) do
    server_id = socket.assigns.server.id

    Server.delete(server_id)

    socket =
      socket
      |> push_navigate(to: "/servers")
      |> put_flash(:info, "Server deleted !")

    {:noreply, socket}
  end

  def handle_event("server_info", unsigned_params, socket) do
    server_name = socket.assigns.server.name

    socket =
      socket
      |> push_patch(to: ~p"/servers/#{server_name}")

    {:noreply, socket}
  end
end
