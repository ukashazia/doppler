defmodule DopplerWeb.ServerLive do
  use DopplerWeb, :live_view
  use Phoenix.HTML
  # use DopplerWeb, :controller

  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  # alias Doppler.Schemas.Server, as: ServerSchema

  def mount(params, _session, socket) do
    server_tags = ServerTags.index()
    server_tags_in_list = get_server_tags_in_list()
    IO.inspect(params)
    servers = servers(params)

    socket =
      socket
      |> assign(
        servers: servers.server,
        server_tags: server_tags,
        server_count: servers.server_count,
        params: params,
        page_title: "Servers",
        server_tags_in_list: server_tags_in_list,
        server_filters: %{}
      )

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    # IO.puts("Handle Params")
    IO.inspect(params)
    # params = socket.assigns.params
    server_tags = ServerTags.index()

    servers = servers(params)

    socket =
      socket
      |> assign(
        servers: servers.server,
        server_tags: server_tags,
        server_count: servers.server_count,
        params: socket.assigns.params
      )

    {:noreply, socket}
  end

  def handle_event("add_btn", _unsigned_params, socket) do
    socket =
      socket
      |> push_navigate(to: "/servers/create")

    {:noreply, socket}
  end

  def handle_event("search_server", %{"name" => server_name}, socket) do
    IO.puts("Server Name: #{server_name}")

    if server_name == "" do
      socket =
        socket
        |> push_patch(to: "/servers")

      {:noreply, socket}
    else
      socket =
        socket
        |> assign(params: %{"name" => server_name})
        |> push_patch(to: "/servers?name=#{server_name}")

      IO.inspect(socket.assigns.params)
      {:noreply, socket}
    end
  end

  def handle_event("server_show", params, socket) do
    # params = socket.assigns.params
    %{"name" => name} = params

    socket =
      socket
      |> push_navigate(to: "/servers/#{name}/info")

    {:noreply, socket}
  end

  def handle_event("server_tag_filter", %{"filters" => filters}, socket) do
    IO.inspect(filters)

    filters =
      filters
      |> Enum.reject(fn {_, v} -> v == "false" end)
      |> Enum.map(fn {k, v} ->
        [k]
      end)
      |> List.flatten()

    filters = %{"tags" => filters}

    socket =
      socket
      |> push_patch(to: ~p"/servers?#{filters}")

    {:noreply, socket}
  end

  defp decode_query_params(query_params) do
    query_params
    |> String.split("&")
    |> Enum.map(fn string ->
      [_, tag] = String.split(string, "=")
      ["#{tag}": true]
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  defp get_server_tags_in_list() do
    Repo.all(Doppler.Schemas.ServerTags)
    |> Enum.map(fn tag ->
      %{name: tag.name, id: tag.id}
    end)
  end

  defp servers(params) do
    IO.inspect(params)

    offset = params["page"] || nil
    name = params["name"] || nil
    tags = params["tags"] || nil

    %{
      server: Server.index(offset, name, tags),
      server_count: Server.server_count(name)
    }
  end
end
