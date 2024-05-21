defmodule Werqit.Repo do
  use Ecto.Repo,
    otp_app: :werqit,
    adapter: Ecto.Adapters.Postgres
end
