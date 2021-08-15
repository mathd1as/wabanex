defmodule Wabanex.Users.Get do
  import Ecto.Query
  alias Wabanex.{Repo, User, Training}
  def call(id) do
    id
    |> Ecto.UUID.cast()
    |> handle_response()
  end

  defp handle_response(:error) do
    {:error, "Invalid UUID"}
  end

  defp handle_response({:ok, uuid}) do
    case Repo.get(User, uuid) do
      nil -> {:error, "User not found"}
      user -> {:ok, load_training(user)}
    end
  end

  defp load_training(user) do
    today = Date.utc_today()

    query = from t in Training, where: ^today >= t.start_date and ^today <= t.end_date

    Repo.preload(user, trainings: {first(query), :exercices})


  end
end
