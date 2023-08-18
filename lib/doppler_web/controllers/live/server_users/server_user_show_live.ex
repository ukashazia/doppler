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

  def handle_event(_event, _unsigned_params, socket) do
    {:noreply, socket}
  end
end
