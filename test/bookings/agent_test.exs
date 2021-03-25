defmodule Flightex.Bookings.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  describe "save/1" do
    setup %{} do
      BookingAgent.start_link(%{})

      :ok
    end

    test "saves the booking" do
      booking = build(:booking)

      assert :ok == BookingAgent.save(booking)
    end
  end

  describe "get/1" do
    setup %{} do
      BookingAgent.start_link(%{})
      :ok
    end

    test "when the booking is found, returns the booking" do
      booking_id = "1e81ab8a-e775-4b26-be80-5537fe156067"
      booking = build(:booking, id: booking_id)

      BookingAgent.save(booking)

      response = BookingAgent.get(booking_id)

      expected_response = {:ok, booking}

      assert expected_response == response
    end

    test "when the booking is not found, returns an error" do
      response = BookingAgent.get("00000000000")

      expected_response = {:error, "Flight Booking not found"}

      assert expected_response == response
    end
  end

  describe "get_all/1" do
    setup %{} do
      BookingAgent.start_link(%{})
      :ok
    end

    test "when there are no bookings, returns empty" do
      response = BookingAgent.get_all()

      assert %{} == response
    end

    test "when there are bookings, returns the bookings" do
      booking_one_id = "1e81ab8a-e775-4b26-be80-5537fe156067"
      booking_one = build(:booking, id: booking_one_id)

      booking_two_id = "7f1ce228-c2c1-4151-b90a-09c379e635de"
      booking_two = build(:booking, id: booking_two_id)

      BookingAgent.save(booking_one)
      BookingAgent.save(booking_two)

      response = BookingAgent.get_all()

      expected_response = %{
              "1e81ab8a-e775-4b26-be80-5537fe156067" => %Booking{
                complete_date: ~N[2020-09-01 12:00:00],
                destination_city: "Cachoeiro de Itapemirim",
                id: "1e81ab8a-e775-4b26-be80-5537fe156067",
                source_city: "Porto",
                user_id: "70831e44-5820-4b4c-aae1-87b079a2882f"
              },
              "7f1ce228-c2c1-4151-b90a-09c379e635de" => %Booking{
                complete_date: ~N[2020-09-01 12:00:00],
                destination_city: "Cachoeiro de Itapemirim",
                id: "7f1ce228-c2c1-4151-b90a-09c379e635de",
                source_city: "Porto",
                user_id: "70831e44-5820-4b4c-aae1-87b079a2882f"
              }
            }

      assert expected_response == response
    end
  end

  describe "get/2" do
    setup %{} do
      BookingAgent.start_link(%{})

      booking_one =
        build(:booking,
          id: "732b0aa0-eb76-4c75-9082-d75d5e9cd01e",
          complete_date: ~N[2020-09-01 12:00:00]
        )

      booking_two =
        build(:booking,
          id: "f36bd4e1-333a-431e-bccb-2634862014ba",
          complete_date: ~N[2020-09-05 12:00:00]
        )

      booking_three =
        build(:booking,
          id: "aaeb12fe-03ff-481d-94e6-d03e3bc05d50",
          complete_date: ~N[2020-10-10 12:00:00]
        )

      BookingAgent.save(booking_one)
      BookingAgent.save(booking_two)
      BookingAgent.save(booking_three)

      :ok
    end

    test "when informed two dates, returns the bookings between the dates interval" do
      response = BookingAgent.get(~N[2020-09-01 00:00:00], ~N[2020-09-30 00:00:00])

      assert {
              :ok,
              [
                %Booking{
                  complete_date: ~N[2020-09-01 12:00:00],
                  destination_city: "Cachoeiro de Itapemirim",
                  source_city: "Porto",
                  user_id: "70831e44-5820-4b4c-aae1-87b079a2882f",
                  id: "732b0aa0-eb76-4c75-9082-d75d5e9cd01e"
                },
                %Booking{
                  complete_date: ~N[2020-09-05 12:00:00],
                  destination_city: "Cachoeiro de Itapemirim",
                  source_city: "Porto",
                  user_id: "70831e44-5820-4b4c-aae1-87b079a2882f",
                  id: "f36bd4e1-333a-431e-bccb-2634862014ba"
                }
              ]
            } = response
    end

    test "when there are no bookings, returns empty" do
      response =
        BookingAgent.get(
          ~N[2020-11-01 00:00:00],
          ~N[2020-11-30 00:00:00]
        )

      expected_response = {:ok, []}

      assert expected_response == response
    end

    test "when params are invalid, returns an error" do
      response = BookingAgent.get("", 123)

      expected_response = {:error, "Invalid params"}

      assert expected_response == response
    end
  end
end
