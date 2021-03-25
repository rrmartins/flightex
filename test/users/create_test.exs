defmodule Flightex.Users.CreateTest do
  use ExUnit.Case

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create

  describe "call/1" do
    setup %{} do
      UserAgent.start_link(%{})

      :ok
    end

    test "when all params are valid, saves the user" do
      params = %{
        name: "Rodrigo",
        email: "rrmartinsjg@gmail.com",
        cpf: "12345678910"
      }

      response = Create.call(params)

      assert {:ok, _user_id} = response
    end

    test "when there are params invalid, returns an error" do
      params = %{
        name: "Rodrigo",
        email: 1_232_131_231,
        cpf: "12345678910"
      }

      response = Create.call(params)

      expected_response = {:error, "Invalid parameters"}

      assert expected_response == response
    end
  end
end
