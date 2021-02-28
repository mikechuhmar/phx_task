defmodule PhxTask.Repo do
  use Ecto.Repo,
    otp_app: :phx_task,
    adapter: Ecto.Adapters.Postgres
end
