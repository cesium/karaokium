defmodule Karaokium.Schema do
  @moduledoc """
  The application Schema for all the modules, providing Ecto.UUIDs as default id.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
    end
  end
end
