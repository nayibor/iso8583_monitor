defmodule Iso8583Monitor.Repo do
  use Ecto.Repo,
    otp_app: :iso8583_monitor,
    adapter: Ecto.Adapters.Postgres
end
