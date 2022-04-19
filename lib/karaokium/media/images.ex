defmodule Karaokium.Media.Images do
  use Ecto.Schema
  import Ecto.Changeset
  alias Karaokium.Media.Images

  embedded_schema do
    field :height, :integer
    field :url, :string
    field :width, :integer
  end

  @doc false
  def changeset(%Images{} = images, attrs) do
    images
    |> cast(attrs, [:width, :height, :url])
    |> validate_required([:width, :height, :url])
  end
end
