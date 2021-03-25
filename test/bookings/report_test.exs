defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Report

  describe "call/2" do
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
    end

    test "creates the report" do
      Report.call(~N[2020-09-01 00:00:00], ~N[2020-09-30 00:00:00])

      response = File.read!("booking_report.csv")

      expected_response =
        "70831e44-5820-4b4c-aae1-87b079a2882f,Porto,Cachoeiro de Itapemirim,2020-09-01 12:00:00\n" <>
          "70831e44-5820-4b4c-aae1-87b079a2882f,Porto,Cachoeiro de Itapemirim,2020-09-05 12:00:00\n"

      assert expected_response == response
    end
  end
end
