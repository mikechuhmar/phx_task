defmodule PhxTask.Auth.Guardian do
  use Guardian, otp_app: :phx_task

  alias PhxTask.Auth

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    Auth.get_user(id)
  end
end
