defmodule TartuBike.BikeSharing.FeeTest do
  use ExUnit.Case
  alias TartuBike.Fee

  test "Calculate total hours for less than 1 hour" do
    # DB time is UTC time -> Zulu time
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T21:57:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-28T22:10:01Z")

    diffHour = Fee.totalHours(start_time, end_time)

    assert diffHour == 1
  end

  test "Calculate total hours for more than 1 day" do
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T00:00:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-29T02:00:00Z")

    diffHour = Fee.totalHours(start_time, end_time)

    assert diffHour == 26
  end

  test "Calculate bike fee for less than 1 hour" do
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T21:57:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-28T22:10:00Z")

    fee = Fee.totalRideFee(start_time, end_time)
    assert fee == {0, 0}
  end

  test "Calculate bike fee for less than 5 hour" do
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T00:00:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-28T04:10:00Z")

    fee = Fee.totalRideFee(start_time, end_time)
    assert fee == {4, 0}
  end

  test "Calculate bike fee with delay" do
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T00:00:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-28T12:00:00Z")

    fee = Fee.totalRideFee(start_time, end_time)
    assert fee == {4, 80}
  end

  test "Calculate bike fee for missing" do
    {_, start_time, _} = DateTime.from_iso8601("2021-11-28T00:00:01Z")
    {_, end_time, _} = DateTime.from_iso8601("2021-11-29T02:00:00Z")

    fee = Fee.totalRideFee(start_time, end_time)
    assert fee == {4, 2500}
  end
end
