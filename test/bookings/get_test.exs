defmodule Flightex.Bookings.GetTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Get

  describe "call/1" do
    setup %{} do
      BookingAgent.start_link(%{})
      :ok
    end

    test "when the booking is found, returns the booking" do
      booking_id = "1e81ab8a-e775-4b26-be80-5537fe156067"
      booking = build(:booking, id: booking_id)

      BookingAgent.save(booking)

      response = Get.call(booking_id)

      expected_response = {:ok, booking}

      assert expected_response == response
    end

    test "when the booking is not found, returns an error" do
      response = BookingAgent.get("00000000000")

      expected_response = {:error, "Flight Booking not found"}

      assert expected_response == response
    end
  end
end
