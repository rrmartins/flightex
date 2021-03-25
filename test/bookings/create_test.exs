defmodule Flightex.Bookings.CreateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create
  alias Flightex.Users.Agent, as: UserAgent

  describe "call/2" do
    setup %{} do
      BookingAgent.start_link(%{})
      UserAgent.start_link(%{})

      user_id = "07f90095-36b7-4e4c-8dca-2a0b578526c2"
      user = build(:user, id: user_id)

      UserAgent.save(user)

      {:ok, user_id: user_id}
    end

    test "when all params are valid, saves the booking", %{user_id: user_id} do
      params = %{
        complete_date: "2020-01-20 10:00:00",
        source_city: "Muqui",
        destination_city: "Cachoeiro de Itapemirim"
      }

      response = Create.call(user_id, params)

      assert {:ok, _booking_id} = response
    end

    test "when there are params invalid, returns an error", %{user_id: user_id} do
      params = %{
        complete_date: "2020-01-20 10:00:00",
        source_city: "Muqui"
      }

      response = Create.call(user_id, params)

      expected_response = {:error, "Invalid params"}

      assert expected_response == response
    end
  end
end
