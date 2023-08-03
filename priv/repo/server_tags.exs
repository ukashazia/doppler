alias Doppler.Schemas.{ServerTags}

tags = [
  %{name: "nsfw"},
  %{name: "other"},
  %{name: "gaming"},
  %{name: "tech"},
  %{name: "entertainment"},
  %{name: "creative"}
]

Enum.each(tags, fn tag ->
  ServerTags.changeset(%ServerTags{}, tag)
  |> Doppler.Repo.insert()
end)
