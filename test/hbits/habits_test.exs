defmodule Hbits.HabitsTest do
  use Hbits.DataCase

  alias Hbits.Habits

  describe "habits" do
    alias Hbits.Habits.Habit

    @valid_attrs %{color: "some color", icon: "some icon", name: "some name"}
    @update_attrs %{color: "some updated color", icon: "some updated icon", name: "some updated name"}
    @invalid_attrs %{color: nil, icon: nil, name: nil}

    def habit_fixture(attrs \\ %{}) do
      {:ok, habit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Habits.create_habit()

      habit
    end

    test "list_habits/0 returns all habits" do
      habit = habit_fixture()
      assert Habits.list_habits() == [habit]
    end

    test "get_habit!/1 returns the habit with given id" do
      habit = habit_fixture()
      assert Habits.get_habit!(habit.id) == habit
    end

    test "create_habit/1 with valid data creates a habit" do
      assert {:ok, %Habit{} = habit} = Habits.create_habit(@valid_attrs)
      assert habit.color == "some color"
      assert habit.icon == "some icon"
      assert habit.name == "some name"
    end

    test "create_habit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Habits.create_habit(@invalid_attrs)
    end

    test "update_habit/2 with valid data updates the habit" do
      habit = habit_fixture()
      assert {:ok, %Habit{} = habit} = Habits.update_habit(habit, @update_attrs)
      assert habit.color == "some updated color"
      assert habit.icon == "some updated icon"
      assert habit.name == "some updated name"
    end

    test "update_habit/2 with invalid data returns error changeset" do
      habit = habit_fixture()
      assert {:error, %Ecto.Changeset{}} = Habits.update_habit(habit, @invalid_attrs)
      assert habit == Habits.get_habit!(habit.id)
    end

    test "delete_habit/1 deletes the habit" do
      habit = habit_fixture()
      assert {:ok, %Habit{}} = Habits.delete_habit(habit)
      assert_raise Ecto.NoResultsError, fn -> Habits.get_habit!(habit.id) end
    end

    test "change_habit/1 returns a habit changeset" do
      habit = habit_fixture()
      assert %Ecto.Changeset{} = Habits.change_habit(habit)
    end
  end
end
