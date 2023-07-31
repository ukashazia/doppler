defmodule Doppler.Repo do
  use Ecto.Repo,
    otp_app: :doppler,
    adapter: Ecto.Adapters.Postgres
end
