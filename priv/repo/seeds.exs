# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Iso8583Monitor.Repo.insert!(%Iso8583Monitor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Iso8583Monitor.Accounts
##create a default admin user whom will have acess to the system
##this user can be used for creating other accounts

{:ok,user} = Accounts.register_user %{email: "admin@monitor.com",password: "qwert12345!@#$%"}
