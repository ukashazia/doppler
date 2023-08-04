defmodule Doppler.Servers.ServerTags do
  alias Doppler.{Repo, Schemas.ServerTags}

  def index() do
    Repo.all(ServerTags)
  end
end
