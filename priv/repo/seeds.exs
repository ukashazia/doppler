# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Doppler.Repo.insert!(%Doppler.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule ServerGenerator do
  def generate_servers do
    names = Enum.shuffle(server_names())
    descriptions = Enum.shuffle(server_descriptions())

    Enum.zip(names, descriptions)
    |> Enum.take(35)
    |> Enum.map(fn {name, description} ->
      %{name: String.replace(name, " ", "_"), description: description}
    end)
  end

  defp server_names do
    [
      "Tech Hub",
      "Design Den",
      "Gaming Guild",
      "Science Lab",
      "Bookworms",
      "Foodie Fiesta",
      "Fitness Freaks",
      "Movie Mania",
      "Music Masters",
      "Artisans' Corner",
      "Travel Trekkers",
      "Photography Pioneers",
      "Pet Lovers Paradise",
      "Fashion Frenzy",
      "History Buffs",
      "Writing Wonders",
      "Nature Lovers",
      "Language Lounge",
      "Finance Forum",
      "Wellness Warriors",
      "DIY Delights",
      "Health Haven",
      "Business Buzz",
      "Cooking Club",
      "Anime Addicts",
      "Coding Central",
      "Outdoor Explorers",
      "Entrepreneur Emporium",
      "Trivia Titans",
      "Fitness Fanatics",
      "Movie Marathoners",
      "Tech Talk",
      "Crafty Creators",
      "Photography Fanatics",
      "Science Explorers",
      "Creative Corner",
      "Gaming Haven",
      "Nature's Wonders",
      "Cooking Connoisseurs",
      "Tech Geeks",
      "Fitness Warriors",
      "Music Mixers",
      "History Enthusiasts",
      "Writing Wizards",
      "Language Exchange",
      "Investment Insights",
      "Yoga Enthusiasts",
      "Artistic Minds",
      "Pet Paradise",
      "Fashionistas United",
      "Outdoor Adventurers",
      "Startup Central",
      "Trivia Fanatics",
      "Wellness Warriors",
      "Crafty Creators",
      "Health & Nutrition",
      "Business Networking",
      "Book Club",
      "Anime Fans Unite",
      "Code Crafters",
      "Wanderlust Travels",
      "Photography Vibes",
      "Food Lovers Society",
      "Movie Buffs Lounge",
      "Designers' Den",
      "Science & Tech Talk",
      "Healthy Living",
      "DIY Crafters",
      "Photographers' Hangout"
    ]
  end

  defp server_descriptions do
    [
      "A community of tech enthusiasts sharing knowledge and ideas.",
      "A place for designers to collaborate and showcase their work.",
      "A gaming server for hardcore gamers to connect and play together.",
      "Exploring the wonders of science with like-minded individuals.",
      "For book lovers to discuss their favorite reads and discover new ones.",
      "All about delicious food and cooking recipes.",
      "Support and motivation for fitness and health goals.",
      "For movie buffs to discuss films and recommend must-watch movies.",
      "Dedicated to all things music – genres, artists, and playlists.",
      "A space for artists and creators to share their work and get inspired.",
      "Travelers sharing their experiences and travel tips.",
      "A community for photography enthusiasts to showcase their shots.",
      "For pet owners to share stories and pictures of their furry friends.",
      "Discussing fashion trends, styling tips, and outfit inspirations.",
      "Exploring historical events, cultures, and heritage.",
      "A place for writers to share their stories and receive feedback.",
      "Connecting nature lovers and sharing breathtaking landscapes.",
      "Learning and discussing different languages from around the world.",
      "Financial advice, investing, and money-saving tips.",
      "Support for mental and physical wellness and self-care.",
      "For DIY lovers to share craft projects and creative ideas.",
      "Promoting health and fitness through workouts and nutrition.",
      "Networking and discussing business strategies and entrepreneurship.",
      "Sharing recipes and cooking tips for home chefs.",
      "For anime enthusiasts to talk about their favorite shows and characters.",
      "Discussing coding languages, programming projects, and tech news.",
      "Exploring outdoor activities like hiking, camping, and more.",
      "For aspiring entrepreneurs to share business ideas and advice.",
      "Trivia challenges and fun quizzes for knowledge seekers.",
      "For gym enthusiasts and fitness challenges.",
      "Organizing movie marathons and watching films together.",
      "Discussions on tech news, gadgets, and software.",
      "For crafters and DIY enthusiasts to showcase their creations.",
      "Discussing photography techniques and tips."
    ]
  end

  all_tags = Doppler.Repo.all(Doppler.Schemas.ServerTags)


servers = ServerGenerator.generate_servers()

Enum.each(servers, fn server ->
  Doppler.Schemas.Server.changeset(%Doppler.Schemas.Server{}, server)
  |> Doppler.Repo.insert()
end)

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
end
# all_tags = Doppler.Repo.all(Doppler.Schemas.ServerTags)
