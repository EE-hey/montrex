defmodule Montrex.Repo do
  use Ecto.Repo,
    otp_app: :montrex,
    adapter: Ecto.Adapters.Postgres
end
