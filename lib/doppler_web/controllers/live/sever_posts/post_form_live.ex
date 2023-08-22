defmodule DopplerWeb.Live.SeverPosts.PostFormLive do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias Phoenix.LiveView.JS

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    post_changeset = Doppler.Schemas.ServerPosts.changeset(%Doppler.Schemas.ServerPosts{}, %{})

    socket =
      socket
      |> assign(
        post_changeset: post_changeset,
        params: assigns
      )

    {:ok, socket}
  end

  def handle_event("change_post", %{"server_posts" => params}, socket) do
    post_changeset = Doppler.Schemas.ServerPosts.changeset(%Doppler.Schemas.ServerPosts{}, params)

    IO.inspect(post_changeset)

    socket =
      socket
      |> assign(post_changeset: post_changeset)

    {:noreply, socket}
  end

  def handle_event("submit_post", %{"server_posts" => params}, socket) do
    post_changeset = Doppler.Schemas.ServerPosts.changeset(%Doppler.Schemas.ServerPosts{}, params)

    server_name = socket.assigns.params.user.server.name
    username = socket.assigns.params.user.username

    if post_changeset.valid? do
      case Doppler.Posts.Posts.add_post(server_name, username, params) do
        {:ok, _post} ->
          socket =
            socket
            |> put_flash(:info, "Post created")
            |> push_navigate(to: "/servers/#{server_name}/users/#{username}/info")

          {:noreply, socket}

        {:error, post_changeset} ->
          socket =
            socket
            |> assign(post_changeset: post_changeset)
            |> put_flash(:error, "Something went wrong")

          {:noreply, socket}
      end
    else
      socket = assign(socket, post_changeset: post_changeset)
      IO.inspect(post_changeset)
      {:noreply, socket}
    end
  end
end
