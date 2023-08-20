defmodule DopplerWeb.Live.ServerPosts.ServerPostsLive do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias Phoenix.LiveView.JS

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    IO.inspect(assigns)
    server_name = assigns.server.name
    server_posts = Doppler.Servers.Server.list_server_posts(server_name)

    socket =
      socket
      |> assign(assigns: assigns, server_posts: server_posts, page_title: "Posts")

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:no_reply, socket}
  end
end
