defmodule Doppler.Servers.ServerTags do
  alias Doppler.{Repo, Schemas.ServerTags}

  def index() do
    Repo.all(ServerTags)
  end

  def index(tag_list) do
    Repo.all(ServerTags)
    |> Enum.filter(fn tag ->
      tag.name in tag_list
    end)
  end
end
