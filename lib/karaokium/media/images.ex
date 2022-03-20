defmodule Karaokium.Media.Images do
  use Ecto.Schema
  import Ecto.Changeset
  alias Karaokium.Media.Images

  embedded_schema do
    field :heigth, :string
    field :url, :string
    field :width, :string
  end

  @doc false
  def changeset(%Images{} = images, attrs) do
    images
    |> cast(attrs, [:width, :heigth, :url])
    |> validate_required([:width, :heigth, :url])
  end
end
