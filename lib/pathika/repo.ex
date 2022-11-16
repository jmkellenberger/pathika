defmodule Pathika.Repo do
  use Ecto.Repo,
    otp_app: :pathika,
    adapter: Ecto.Adapters.Postgres
end
