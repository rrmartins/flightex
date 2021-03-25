defmodule Flightex.Users.UserTest do
  use ExUnit.Case

  alias Flightex.Users.User

  describe "build/3" do
    test "when all params are valid, returns the user" do
      response = User.build("Rodrigo", "rrmartinsjg@gmail.com", "12345678910")

      assert {
               :ok,
               %User{
                 cpf: "12345678910",
                 email: "rrmartinsjg@gmail.com",
                 name: "Rodrigo"
               }
             } = response
    end

    test "when there are params invalid, returns an error" do
      response = User.build("Rodrigo", "rrmartinsjg@gmail.com", 100)

      expected_response = {:error, "Invalid parameters"}

      assert expected_response == response
    end
  end
end
