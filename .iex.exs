import_file_if_available("~/.iex.exs")
import_file_if_available(".iex.local.exs")

import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

alias Karaokium.{
  Accounts,
  Events,
  Groups,
  Media,
  Performances,
  Polling,
  Repertoire,
  Stats
}
