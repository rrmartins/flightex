defmodule Flightex.Users.User do
  @keys [:id, :name, :email, :cpf]
  @enforce_keys @keys

  defstruct @keys

  def build(name, email, cpf)
      when is_bitstring(name) and is_bitstring(email) and is_bitstring(cpf) do
    new_id = UUID.uuid4()

    {:ok,
      %__MODULE__{
        id: new_id,
        name: name,
        email: email,
        cpf: cpf
      }
    }
  end

  def build(_name, _email, _cpf), do: {:error, "Invalid parameters"}
end
