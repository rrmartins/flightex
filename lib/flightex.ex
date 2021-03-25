defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create, as: CreateBooking
  alias Flightex.Bookings.Get, as: GetBooking
  alias Flightex.Bookings.Report, as: BookingReport
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create, as: CreateUser

  @doc """
  Starts the agents.

  ## Examples

      iex> Flightex.start_agents()
      {:ok, "Agents started"}

  """
  def start_agents do
    UserAgent.start_link(%{})
    BookingAgent.start_link(%{})

    {:ok, "Agents started"}
  end

  @doc """
  Create an user.

  ## Examples

      iex> Flightex.create_user(%{})
      {:error, "Invalid params"}

      _iex> Flightex.create_user(%{name: "Rodrigo Martins", email: "rrmartinsjg@gmail.com", cpf: "12345678910"})
      {:ok, _user_id}

  """
  defdelegate create_user(params), to: CreateUser, as: :call

  @doc """
  Create a booking.

  ## Examples

      iex> Flightex.create_booking("invalid", %{complete_date: "2020-09-01 10:00:00",source_city: "Porto", destination_city: "Cachoeiro de Itapemirim"})
      {:error, "User not found"}

      iex> Flightex.create_booking("invalid", %{})
      {:error, "Invalid params"}

      _iex> Flightex.create_booking("07f90095-36b7-4e4c-8dca-2a0b578526c2", %{complete_date: "2020-09-01 10:00:00",source_city: "Porto", destination_city: "Cachoeiro de Itapemirim"})
      {:ok, booking_id}

  """
  defdelegate create_booking(user_id, params), to: CreateBooking, as: :call

  @doc """
  Get a booking.

  ## Examples

      iex> Flightex.get_booking("1e81ab8a-e775-4b26-be80-5537fe156067")
      {
        :ok,
        %Flightex.Bookings.Booking{
          destination_city: "Cachoeiro de Itapemirim",
          source_city: "Porto",
          complete_date: ~N[2020-09-01 12:00:00],
          id: "1e81ab8a-e775-4b26-be80-5537fe156067",
          user_id: "70831e44-5820-4b4c-aae1-87b079a2882f"
        }
      }

      iex> Flightex.get_booking("invalid")
      {:error, "Flight Booking not found"}

  """
  defdelegate get_booking(booking_id), to: GetBooking, as: :call

  @doc """
  Generates a booking report.

  ## Examples

      iex> Flightex.generate_report(~N[2020-09-01 00:00:00], ~N[2020-09-30 00:00:00])
      {:ok, "Report generated successfully"}

  """
  defdelegate generate_report(from_date, to_date), to: BookingReport, as: :call
end
