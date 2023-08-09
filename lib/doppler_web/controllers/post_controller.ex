defmodule DopplerWeb.PostController do
  use DopplerWeb, :controller
  alias Doppler.{Servers.Server, Servers.ServerTags, Repo}
  alias Doppler.Schemas.Server, as: ServerSchema
end
