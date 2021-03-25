defmodule Flightex.Bookings.BookingTest do
  use ExUnit.Case

  alias Flightex.Bookings.Booking

  describe "build/4" do
    test "when all params are valid, returns the booking" do
      response =
        Booking.build(
          ~N[2020-09-01 12:00:00],
          "Cachoeiro de Itapemirim",
          "Porto",
          "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
        )

      assert {
               :ok,
               %Booking{
                 destination_city: "Porto",
                 source_city: "Cachoeiro de Itapemirim",
                 complete_date: ~N[2020-09-01 12:00:00],
                 user_id: "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
               }
             } = response
    end

    test "when date is an valid string, returns the booking" do
      response =
        Booking.build(
          "2020-09-01 12:00:00",
          "Cachoeiro de Itapemirim",
          "Porto",
          "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
        )

      assert {
               :ok,
               %Booking{
                 destination_city: "Porto",
                 source_city: "Cachoeiro de Itapemirim",
                 complete_date: ~N[2020-09-01 12:00:00],
                 user_id: "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
               }
             } = response
    end

    test "when there are params invalid, returns an error" do
      response =
        Booking.build(
          "2020-09-01 12:00:00",
          :city,
          "Porto",
          "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
        )

      expected_response = {:error, "Invalid parameters"}

      assert expected_response == response
    end

    test "when cannot convert string to date, returns an error" do
      response =
        Booking.build(
          "2020-09-01",
          "Cachoeiro de Itapemirim",
          "Porto",
          "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
        )

      expected_response = {:error, "Invalid date, cannot convert string to date"}

      assert expected_response == response
    end

    test "when date is invalid, returns an error" do
      response =
        Booking.build(
          :date,
          "Cachoeiro de Itapemirim",
          "Porto",
          "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"
        )

      expected_response = {:error, "Invalid date"}

      assert expected_response == response
    end
  end
end
