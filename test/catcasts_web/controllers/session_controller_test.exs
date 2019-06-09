defmodule CatcastsWeb.SessionControllerTest do
  use CatcastsWeb.ConnCase
  alias Catcasts.{Repo, User}

  @ueberauth_auth %{
    credentials: %{token: "fdsnoafhnoofh08h38h"},
    info: %{email: "dan.ugolini@gmail.com", first_name: "Daniele", last_name: "Ugolini"},
    provider: :google
  }

  test "Redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert redirected_to(conn, 302)
  end

  test "Creates user from Google information", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end
end