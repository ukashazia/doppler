defmodule DopplerWeb.UserController do
  use DopplerWeb, :controller
  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema

  def index(conn, %{"name" => name}) do
    case Server.get_server_users(name) do
      {:ok, server} ->
        conn
        |> render(:index, server: server)

      {:error} ->
        conn
        |> render(:server404)
    end
  end

  # def create(conn, user_params) do
  #   case Server.add_user(user_params) do
  #     {:ok, _user} ->
  #       conn
  #       |> redirect(to: "/servers/#{server.name}/users")
  #       |> put_flash(:info, "User created successfully.")

  #     {:error, %Ecto.Changeset{}} ->
  #       conn
  #       |> put_flash(:error, "Failed to create user, something went wrong.")
  #       |> redirect(to: "/servers/#{server.name}/users")
  #   end
  # end
end
