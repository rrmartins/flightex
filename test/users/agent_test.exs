defmodule Flightex.Users.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent

  setup %{} do
    UserAgent.start_link(%{})

    :ok
  end

  describe "save/1" do
    test "saves the user" do
      user = build(:user)

      assert :ok == UserAgent.save(user)
    end
  end

  describe "get/1" do
    test "when the user is found, returns the user" do
      user_id = "61c29ff8-bb7b-43eb-a1ab-b81588bed49a"

      user = build(:user, id: user_id)

      user
      |> UserAgent.save()

      response =
        user_id
        |> UserAgent.get()

      expected_response = {:ok, user}

      assert expected_response == response
    end

    test "when the user is not found, returns an error" do
      response = UserAgent.get("00000000000")

      expected_response = {:error, "User not found"}

      assert expected_response == response
    end
  end
end
