defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking), do: Agent.update(__MODULE__, &update_state(&1, booking))

  def get(id), do: Agent.get(__MODULE__, &get_booking(&1, id))

  def get_all, do: Agent.get(__MODULE__, & &1)

  def get(%NaiveDateTime{} = from_date, %NaiveDateTime{} = to_date) do
    bookings =
      get_all()
      |> Enum.filter(fn {_booking_id, %Booking{complete_date: complete_date}} ->
        from = NaiveDateTime.compare(complete_date, from_date)
        to = NaiveDateTime.compare(complete_date, to_date)

        (from == :eq or from == :gt) and (to == :eq or to == :lt)
      end)
      |> Enum.map(fn {_booking_id, %Booking{} = booking} -> booking end)

    {:ok, bookings}
  end

  def get(_from_date, _to_date), do: {:error, "Invalid params"}

  defp update_state(state, %Booking{id: id} = booking), do: Map.put(state, id, booking)

  defp get_booking(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "Flight Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
