defmodule DopplerWeb.Live.ServerUsers.ServerUserShowLive do
  use DopplerWeb, :live_view

  def mount(params, _session, socket) do
    username = params["username"]
    user = Doppler.Users.User.get_user(username, params["name"])
    user_posts = Doppler.Posts.Posts.get_posts(username, params["name"])

    socket =
      socket
      |> assign(
        user: user,
        user_posts: user_posts,
        params: params,
        page_title: "#{username}"
      )

    {:ok, socket}
  end

  def handle_event("remove_user", _params, socket) do
    username = socket.assigns.user.username
    server_name = socket.assigns.user.server.name

    case Doppler.Servers.Server.remove_server_user(username, server_name) do
      {:error, message} ->
        socket =
          socket
          |> put_flash(:error, message)
          |> push_navigate(to: ~p"/servers/#{server_name}/users")

        {:noreply, socket}

      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "User removed")
          |> push_navigate(to: ~p"/servers/#{server_name}/users")

        {:noreply, socket}
    end
  end
end
