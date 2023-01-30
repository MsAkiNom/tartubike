defmodule TartuBike.ProblemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TartuBike.Problems` context.
  """

  @doc """
  Generate a report.
  """
  def report_fixture(attrs \\ %{}) do
    {:ok, report} =
      attrs
      |> Enum.into(%{
        bike_id: 42,
        issue: "some issue",
        title: "some title"
      })
      |> TartuBike.Problems.create_report()

    report
  end
end
