defmodule DopplerWeb.ServerHTML do
  use DopplerWeb, :html
  use Phoenix.HTML
  alias Doppler.{Schemas.ServerTags, Repo}

  embed_templates "server_html/*"

  def get_server_tags_in_list() do
    Repo.all(ServerTags)
    |> Enum.map(fn tag ->
      {String.to_atom(tag.name), tag.id}
    end)
  end
end
