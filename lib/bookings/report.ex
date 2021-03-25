defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def call(from_date, to_date) do
    booking_list = build_booking_list(from_date, to_date)

    File.write!("booking_report.csv", booking_list)

    {:ok, "Report generated successfully"}
  end

  defp build_booking_list(%NaiveDateTime{} = from_date, %NaiveDateTime{} = to_date) do
    BookingAgent.get(from_date, to_date)
      |> map_bookings()
  end

  defp map_bookings({:ok, bookings}) do
    bookings
      |> Enum.map(&booking_string/1)
  end

  defp booking_string(%Booking{
         complete_date: complete_date,
         source_city: source_city,
         destination_city: destination_city,
         user_id: user_id
       }) do
    "#{user_id},#{source_city},#{destination_city},#{NaiveDateTime.to_string(complete_date)}\n"
  end
end
