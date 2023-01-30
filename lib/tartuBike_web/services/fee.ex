defmodule TartuBike.Fee do

  alias TartuBike.Repo
  alias TartuBike.BikeSharing.{Ride, Booking}
  import Ecto.Query, only: [from: 2]

  def totalHours(started_at, ended_at) do
    diff = DateTime.diff(ended_at, started_at)
    diff / 3600 |> ceil
  end

  def totalRideFee(started_at, ended_at) do
    hours = totalHours(started_at, ended_at)
    case hours do
      h when h > 24 -> {4, 2500}
      h when h > 5 ->  {4, 80}
      h when h > 1 and h <= 5 -> {hours - 1, 0}
      _ -> {0, 0}
    end

    # €80 delay unless report problem
    # €2500 for missing
    # insert your issue id to avoid payment
  end

  defp findBookingTime(ride_id) do
    query =
      from b in Booking,
      where: b.ride_id == ^ride_id,
      select: b

    if Repo.exists?(query) , do: Repo.one(query).booked_at , else: nil
  end

  defp findRide(ride_id) do
    query =
      from r in Ride,
      where: r.id == ^ride_id,
      select: r

    Repo.one(query)
  end

  def calculate(ride_id) do
    bookedTime = findBookingTime(ride_id)
    ride = findRide(ride_id)

    start_time = if bookedTime == nil, do: ride.started_at, else: bookedTime
    {fee, charged} = totalRideFee(start_time, ride.ended_at)
    {fee, start_time, ride.ended_at, charged}
  end

end
