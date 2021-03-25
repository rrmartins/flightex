defmodule Flightex.Bookings.Booking do
  @keys [:id, :complete_date, :source_city, :destination_city, :user_id]
  @enforce_keys @keys

  defstruct @keys

  def build(complete_date, source_city, destination_city, user_id)
      when is_bitstring(source_city) and is_bitstring(destination_city) and
             is_bitstring(user_id) do
    new_id = UUID.uuid4()

    parse_date(complete_date)
    |> handle_build(new_id, source_city, destination_city, user_id)
  end

  def build(_complete_date, _source_city, _destination_city, _user_id) do
    {:error, "Invalid parameters"}
  end

  defp handle_build({:error, reason}, _id, _source_city, _destination_city, _user_id) do
    {:error, reason}
  end

  defp handle_build(complete_date, id, source_city, destination_city, user_id) do
    {:ok,
     %__MODULE__{
       id: id,
       complete_date: complete_date,
       source_city: source_city,
       destination_city: destination_city,
       user_id: user_id
     }}
  end

  defp parse_date(date) when is_bitstring(date) do
    case NaiveDateTime.from_iso8601(date) do
      {:ok, date} -> date
      {:error, _reason} -> {:error, "Invalid date, cannot convert string to date"}
    end
  end

  defp parse_date(%NaiveDateTime{} = date), do: date

  defp parse_date(_date), do: {:error, "Invalid date"}
end
