defmodule Flightex.Factory do
  use ExMachina

  alias Flightex.Bookings.Booking
  alias Flightex.Users.User

  def user_factory do
    %User{
      name: "Rodrigo",
      email: "rrmartinsjg@gmail.com",
      cpf: "99999999999",
      id: "c59f5af2-4117-4b42-8cf3-9da7b3dc1e29"
    }
  end

  def booking_factory do
    %Booking{
      id: "939fde23-294b-46f1-9692-a7a6007f8557",
      source_city: "Porto",
      destination_city: "Cachoeiro de Itapemirim",
      complete_date: ~N[2020-09-01 12:00:00],
      user_id: "70831e44-5820-4b4c-aae1-87b079a2882f"
    }
  end
end
