defmodule Hexedio.Auth.Pipeline do
  use Guardian.Plug.Pipeline, 
    otp_app: :hexedio,
    error_handler: Hexedio.Auth.ErrorHandler,
    module: Hexedio.Auth.Guardian

  #If there's a session token, validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  #If there's an auth header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  #Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true

end
