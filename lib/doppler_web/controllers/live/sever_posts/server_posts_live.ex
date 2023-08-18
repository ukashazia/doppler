defmodule DopplerWeb.Live.ServerPosts.ServerPostsLive do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    IO.inspect(assigns)

    socket =
      socket
      |> assign(assigns: assigns)

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:no_reply, socket}
  end
end
