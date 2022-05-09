import_file_if_available("~/.iex.exs")

import Ecto.Changeset
import Ecto.Query

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
