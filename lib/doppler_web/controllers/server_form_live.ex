defmodule DopplerWeb.ServerFormLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
  # use DopplerWeb, :controller

  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema

  def mount(params, _session, socket) do
    server_tags = ServerTags.index()
    changeset = ServerSchema.changeset(%ServerSchema{} |> Repo.preload(:server_tags))
    # IO.inspect(%ServerSchema{} |> Repo.preload(:server_tags))

    socket =
      socket
      |> assign(
        server_tags: server_tags,
        changeset: changeset
      )

    # IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def get_server_tags_in_list() do
    Repo.all(Doppler.Schemas.ServerTags)
    |> Enum.map(fn tag ->
      {String.to_atom(tag.name), tag.id}
    end)
  end

  def handle_params(unsigned_params, uri, socket) do
    {:noreply, socket}
  end

  def handle_event("create_server", %{"server" => server_params}, socket) do
    # server_params = Map.new(server_params, fn {key, value} -> {String.to_atom(key), value} end)
    IO.inspect(server_params)

    case Server.add_server(server_params) do
      {:ok, _server} ->
        {:noreply,
         socket
         |> put_flash(:info, "Server created successfully.")
         |> push_redirect(to: ~p"/servers")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)
         |> put_flash(:error, "Server not created.")}
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

    changeset =
      ServerSchema.changeset(%ServerSchema{}, server_params)
      |> Ecto.Changeset.put_assoc(:server_tags, tag)

    IO.inspect(changeset)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("to_servers", _unsigned_params, socket) do
    socket = socket
      |> push_navigate(to: ~p"/servers")

    {:noreply, socket}
  end
end
