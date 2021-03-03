defmodule PhxTask.Auth.Guardian do
  use Guardian, otp_app: :phx_task

  alias PhxTask.Auth

  # def subject_for_token(user, _claims) do
  #   sub = to_string(user.id)
  #   {:ok, sub}
  # end

  # def resource_from_claims(%{"sub" => id}) do
  #   user = Auth.get_user!(id)
  #   {:ok, user}
  # end

  # def resource_from_claims(_claims) do
  #   {:error, :resource_not_found}
  # end
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Auth.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
