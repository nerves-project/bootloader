defmodule Bootloader.Overlay do
  alias Bootloader.Utils

  defstruct [hash: nil, delta: []]

  @type t :: %__MODULE__{
    hash: String.t,
    delta: [Bootloader.Application.t]
  }

  def load(sources, targets) do
    delta = Bootloader.Application.compare(sources, targets)
    %__MODULE__{
      delta: delta
    }
  end

  def apply(%__MODULE__{} = overlay, overlay_dir) do
    overlay_path = Path.join(overlay_dir, hash(overlay.delta))
    Enum.each(overlay.delta, &Bootloader.Application.apply(&1, overlay_path))
  end

  def hash(applications) do
      applications
      |> Enum.map(& &1.hash)
      |> Enum.join
      |> Utils.hash
  end

end
