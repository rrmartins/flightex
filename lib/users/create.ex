defmodule Flightex.Users.Create do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(%{name: name, email: email, cpf: cpf}) do
    name
    |> User.build(email, cpf)
    |> save_user()
  end

  def call(_params), do: {:error, "Invalid params"}

  defp save_user({:ok, %User{id: id} = user}) do
    UserAgent.save(user)

    {:ok, id}
  end

  defp save_user({:error, _reason} = error), do: error
end
