defmodule DopplerWeb.ServerLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
  # use DopplerWeb, :controller

  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema

  def mount(params, _session, socket) do
    IO.inspect(params)
    server_tags = ServerTags.index()

    servers =
      case params do
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

    socket =
      socket
      |> assign(
        servers: servers.server,
        server_tags: server_tags,
        server_count: servers.server_count,
        params: params,
        page_title: "Servers"
      )

    # IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    IO.puts("Handle Params")
    IO.inspect(params)
    params = socket.assigns.params
    server_tags = ServerTags.index()

    # IO.inspect(%ServerSchema{} |> Repo.preload(:server_tags))

    servers =
      case params do
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

    socket =
      socket
      |> assign(
        servers: servers.server,
        server_tags: server_tags,
        server_count: servers.server_count,
        params: params
      )

    {:noreply, socket}
  end

  def handle_event("add_btn", unsigned_params, socket) do
    socket =
      socket
      |> push_navigate(to: "/servers/create")

    {:noreply, socket}
  end

  def handle_event("search_server", %{"name" => server_name}, socket) do
    IO.puts("Server Name: #{server_name}")

    socket =
      socket
      |> assign(params: %{"name" => server_name})
      |> push_patch(to: "/servers")

    IO.inspect(socket.assigns.params)
    {:noreply, socket}
  end

  def handle_event("server_show", params, socket) do
    # params = socket.assigns.params
    %{"name" => name} = params

    socket =
      socket
      |> push_navigate(to: "/servers/#{name}")

    {:noreply, socket}
  end
end
