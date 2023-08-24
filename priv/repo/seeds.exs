alias Doppler.Repo
import Ecto.Query

defmodule ServerGenerator do
  def generate_servers do
    names = Enum.shuffle(server_names())
    descriptions = Enum.shuffle(server_descriptions())

    Enum.zip(names, descriptions)
    |> Enum.take(100)
    |> Enum.map(fn {name, description} ->
      %{name: String.replace(name, " ", "_"), description: description}
    end)
  end

  defp server_names do
    [
      "GamingHaven",
      "ChatCove",
      "TechTalkPlaza",
      "ArtisticRealm",
      "StudyNexusHub",
      "MusicMingleLair",
      "FoodieFellowship",
      "SportsChatterBox",
      "TravelTalesDen",
      "MovieManiaHub",
      "BookWormHaven",
      "FitnessFusion",
      "FashionFiesta",
      "PetPalsParlor",
      "DebateDen",
      "PhotographyFrenzy",
      "DIYDiscovery",
      "WritingWhirlpool",
      "CodingCafe",
      "MemesMansion",
      "ScienceSpectrum",
      "PoliticsPulse",
      "NatureNook",
      "AnimeArtistry",
      "PodcastPlaza",
      "WellnessWorld",
      "RelationshipRendezvous",
      "CareerCorner",
      "LanguageLounge",
      "HistoryHuddle",
      "FitnessFever",
      "GamingGalaxy",
      "TechTonic",
      "ArtisanAlcove",
      "StudyHive",
      "MusicMagic",
      "FoodFables",
      "SportsArena",
      "WanderlustJunction",
      "MovieMarvels",
      "BookishBuffet",
      "HealthHarbor",
      "FashionFlair",
      "PetPalsPlace",
      "CivilDiscourse",
      "ShutterSquad",
      "DIYDynasty",
      "WordsmithWorld",
      "CodeCabinet",
      "MemeMingle",
      "SciFiSanctum",
      "CivicSquare",
      "WildernessWatch",
      "AnimeAnnex",
      "AudioAtrium",
      "MindfulnessMansion",
      "LoveLane",
      "ProfessionPavilion",
      "LinguistLair",
      "TimeTravelTavern",
      "MotionPictureMajesty",
      "LiteraryLounge",
      "WellnessWagon",
      "HeartToHeartHub",
      "CareerClimbCollective",
      "CultureConnect",
      "EvolutionEmporium",
      "FitnessFusionX",
      "PixelPlayground",
      "TechnoTemple",
      "AestheticArk",
      "StudyNook",
      "HarmonyHype",
      "CulinaryCanvas",
      "SportsSaga",
      "RoamersRendezvous",
      "CinemaCelestial",
      "BookshelfBabble",
      "WellbeingWorld",
      "StyleSyndicate",
      "FurryFellowship",
      "PensivePlunge",
      "GreenThumbGrove",
      "NerdNook",
      "EchoChamber",
      "WanderersHaven",
      "Scriptorium",
      "FutureFocus",
      "GalaxyGalleria",
      "TechTalkTemple",
      "CraftersCorner",
      "MusicMingleManor",
      "FlavorFiesta",
      "AthleteAsylum",
      "NomadNest",
      "SceneScreening",
      "LiteraryLair",
      "HealthfulHarbor",
      "FashionFusion",
      "PetPalsParade"
    ]
  end

  defp server_descriptions do
    [
      "Connect with fellow gamers!",
      "A cozy place to chat and hang out.",
      "Discussions about all things tech.",
      "Express your artistic talents here.",
      "Serious studying and knowledge sharing.",
      "Share and discover music from all genres.",
      "For food enthusiasts to exchange recipes.",
      "Sports fans unite for lively conversations.",
      "Share your travel stories and tips.",
      "For movie buffs and film discussions.",
      "Dive into the world of books and reading.",
      "Get fit and healthy together.",
      "Explore the latest fashion trends.",
      "For pet lovers to share adorable moments.",
      "Engage in respectful and insightful debates.",
      "Showcase your photography skills.",
      "Create, craft, and learn through DIY.",
      "Discuss writing, poetry, and literature.",
      "Coding, programming, and tech talk.",
      "Share and enjoy hilarious memes.",
      "Science and curiosity in action.",
      "Calm discussions on politics and news.",
      "Appreciate and discuss nature's wonders.",
      "Celebrate anime and artistic creations.",
      "Listen to podcasts and share favorites.",
      "Focus on mental and physical wellness.",
      "Relationship advice and support.",
      "Explore career opportunities and advice.",
      "Language learning and cultural exchange.",
      "Delve into history and historical events.",
      "A place for fitness enthusiasts.",
      "Gaming community with a galactic twist.",
      "Stay updated on the latest tech trends.",
      "Artisan crafts and creative expression.",
      "Serious studying and academic discussions.",
      "Share and appreciate diverse music.",
      "For food lovers and culinary enthusiasts.",
      "Discuss and follow sports events.",
      "Exchange travel experiences and tips.",
      "Discuss movies and cinematic experiences.",
      "Bookworms unite for literary talks.",
      "Health and wellness tips and support.",
      "Explore fashion styles and trends.",
      "Share adorable pet stories and photos.",
      "Thoughtful discussions on various topics.",
      "Photography enthusiasts and discussions.",
      "DIY projects, crafts, and creations.",
      "Share your writing and engage in discussions.",
      "Discuss coding projects and programming.",
      "Laugh and enjoy a variety of memes.",
      "Science fiction and fantasy discussions.",
      "Calm and respectful political discussions.",
      "Appreciate and protect the wilderness.",
      "Anime discussions, fanart, and more.",
      "Share and discuss audio content.",
      "Focus on mindfulness and well-being.",
      "Discuss love, relationships, and advice.",
      "Explore career paths and development.",
      "Language learning and linguistic debates.",
      "Time travel discussions and theories.",
      "Explore movies and filmmaking.",
      "Literary discussions and book recommendations.",
      "Support for mental and physical well-being.",
      "Heartfelt discussions and connections.",
      "Advancement in your career journey.",
      "Celebrate diverse cultures and traditions.",
      "Discuss human evolution and history.",
      "Advanced fitness and training strategies.",
      "Share and discuss pixel art and designs.",
      "Cutting-edge technology and discussions.",
      "Appreciate aesthetics and creativity.",
      "Quiet space for focused studying.",
      "Harmonious discussions on various topics.",
      "Delve into the culinary arts and cooking.",
      "Explore sports events and news.",
      "Share your travel stories and tips.",
      "Appreciate movies and cinematic experiences.",
      "Book recommendations and reading talks.",
      "Wellness tips for a balanced life.",
      "Explore personal style and fashion advice.",
      "Connect with fellow furries and enthusiasts.",
      "Contemplative discussions and thoughts.",
      "Share gardening tips and plant care.",
      "Embrace your inner nerd and geek out.",
      "Thoughtful discussions in a cozy space.",
      "Wanderers' tales and travel tips.",
      "Share and critique written works.",
      "Explore futuristic concepts and ideas.",
      "Astronomy, science, and space talk.",
      "Tech discussions and learning opportunities.",
      "Crafting ideas and creative projects.",
      "Discuss and enjoy a variety of music.",
      "Dive into flavorful culinary experiences.",
      "For athletes and sports enthusiasts.",
      "Share nomadic lifestyles and experiences.",
      "Scene discussions and film analysis.",
      "Literary discussions and reading recommendations.",
      "Wellness tips and healthy living advice.",
      "Fusing fashion styles and design ideas.",
      "Share heartwarming pet stories and photos."
    ]
  end
end

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

defmodule Populate do
  def add_doppler(), do: Doppler.Servers.Server.add_server(%{name: "doppler"})
  def add_users(100), do: nil

  def add_users(counter) do
    username = Faker.Internet.user_name()
    email = Faker.Internet.free_email()
    user_params = %{username: username, email: email}
    Doppler.Servers.Server.add_user("doppler", user_params)
    add_users(counter + 1)
  end

  def add_posts(23), do: nil

  def add_posts(counter) do
    server_name = "doppler"

    [user_name] =
      Repo.all(Doppler.Schemas.ServerUsers)
      |> Enum.map(fn user -> user.username end)
      |> Enum.take_random(1)

    body =
      Faker.Lorem.paragraphs(1..10)
      |> Enum.join(" ")

    title = Faker.Lorem.Shakespeare.En.romeo_and_juliet()

    Doppler.Posts.Posts.add_post(server_name, user_name, %{title: title, body: body})
    add_posts(counter + 1)
  end
end

Populate.add_doppler()
Populate.add_users(1)
Populate.add_posts(1)
