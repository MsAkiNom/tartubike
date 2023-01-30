defmodule TartuBike.ProblemsTest do
  use TartuBike.DataCase

  alias TartuBike.Problems

  describe "reports" do
    alias TartuBike.Problems.Report

    import TartuBike.ProblemsFixtures

    @invalid_attrs %{bike_id: nil, issue: nil, title: nil}

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Problems.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Problems.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      valid_attrs = %{bike_id: 42, issue: "some issue", title: "some title"}

      assert {:ok, %Report{} = report} = Problems.create_report(valid_attrs)
      assert report.bike_id == 42
      assert report.issue == "some issue"
      assert report.title == "some title"
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Problems.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      update_attrs = %{bike_id: 43, issue: "some updated issue", title: "some updated title"}

      assert {:ok, %Report{} = report} = Problems.update_report(report, update_attrs)
      assert report.bike_id == 43
      assert report.issue == "some updated issue"
      assert report.title == "some updated title"
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Problems.update_report(report, @invalid_attrs)
      assert report == Problems.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Problems.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Problems.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Problems.change_report(report)
    end
  end
end
