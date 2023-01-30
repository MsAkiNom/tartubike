defmodule TartuBike.BikeSharing.DockTest do
  use ExUnit.Case
  alias TartuBike.BikeSharing.Dock

  test "Dock capacity should be positive" do
    dock = Dock.changeset(%Dock{}, %{name: "Narva 25", capacity: -10, location: "Narva 34"})
    assert Keyword.has_key? dock.errors, :capacity
  end
end
