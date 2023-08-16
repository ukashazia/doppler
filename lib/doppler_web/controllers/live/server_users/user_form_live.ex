defmodule DopplerWeb.Live.ServerUsers.UserFormLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML

  alias Doppler.{Servers.Server}
  alias Doppler.Schemas.ServerUsers, as: UserSchema

  def mount(params, _session, socket) do
    server_name = Map.get(params, "name")
    {:ok, server} = Server.get_server(server_name)
    # server_tags = ServerTags.index()
    changeset = UserSchema.changeset(%UserSchema{})
    # IO.inspect(%ServerSchema{} |> Repo.preload(:server_tags))
    IO.inspect(changeset)

    socket =
      socket
      |> assign(
        changeset: changeset,
        server: server
      )

    # IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("create_user", %{"server_users" => user_params}, socket) do
    # server_params = Map.new(server_params, fn {key, value} -> {String.to_atom(key), value} end)

    server_name = socket.assigns.server.name

    case Server.add_user(server_name, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully.")
         |> push_redirect(to: ~p"/servers/#{server_name}/users")}

      {:error, changeset} ->
        IO.inspect(changeset)

        {:noreply,
         socket
         |> assign(changeset: changeset)
         |> put_flash(:error, "Server not created, check errors.")}
    end
  end

  def handle_event("change_user", %{"server_users" => user_params}, socket) do
    server = socket.assigns.server
    IO.inspect(user_params)

    changeset =
      UserSchema.changeset(%UserSchema{}, user_params)
      |> Ecto.Changeset.put_assoc(:server, server)

    IO.inspect(changeset)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("to_users", _unsigned_params, socket) do
    server_name = socket.assigns.server.name

    socket =
      socket
      |> push_navigate(to: ~p"/servers/#{server_name}/users")

    {:noreply, socket}
  end
end
