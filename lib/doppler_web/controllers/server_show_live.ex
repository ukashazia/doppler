defmodule DopplerWeb.ServerShowLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
  alias Phoenix.LiveView.JS
  alias Doppler.{Servers.Server}
  alias Doppler.Schemas.Server, as: ServerSchema
  alias Doppler.{Servers.Server, Repo}

  def mount(params, _session, socket) do
    server_name = Map.get(params, "name")
    user_count = Server.server_user_count(server_name)

    case Server.get_server(server_name) do
      {:ok, server} ->
        changeset =
          Doppler.Schemas.Server.changeset(server |> Doppler.Repo.preload(:server_tags), %{})

        socket =
          socket
          |> assign(
            server: server,
            params: params,
            page_title: "#{server.name}",
            user_count: user_count,
            changeset: changeset
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

  def handle_params(_params, _url, socket) do
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

  def handle_event("update_server", %{"server" => params}, socket) do
    server_name = socket.assigns.server.name

    tag =
      if tagid = Map.get(params, "server_tags") do
        Enum.map(tagid, fn x ->
          tag_struct = Repo.get(Doppler.Schemas.ServerTags, x)
          tag_struct.name
        end)
      else
        []
      end

    params = Map.put(params, "server_tags", tag)

    case Doppler.Servers.Server.update_server(server_name, params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Updated!")
          |> push_navigate(to: "/servers/#{params["name"]}/info")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: changeset)

        {:noreply, socket}
    end
  end

  def handle_event("change_server", %{"server" => server_params}, socket) do
    tag =
      if tagid = Map.get(server_params, "server_tags") do
        Enum.map(tagid, fn x ->
          %{id: String.to_integer(x)}
          Repo.get(Doppler.Schemas.ServerTags, x)
        end)
      else
        []
      end

    # server_params = Map.put(server_params, "server_tags", tag)
    IO.inspect(tag)
    IO.inspect(server_params)
    {:ok, server} = Server.get_server(socket.assigns.server.name)

    changeset =
      ServerSchema.changeset(server, server_params)
      |> Ecto.Changeset.put_assoc(:server_tags, tag)

    IO.inspect(changeset)
    {:noreply, assign(socket, changeset: changeset)}
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
