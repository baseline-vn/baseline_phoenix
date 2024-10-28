defmodule BaselinePhoenixWeb.Plugs.SetLocale do
  import Plug.Conn

  @locales Gettext.known_locales(BaselinePhoenixWeb.Gettext)

  def init(default_locale), do: default_locale

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _default_locale)
      when locale in @locales do
    set_locale(conn, locale)
  end

  def call(conn, default_locale) do
    set_locale(conn, conn.cookies["locale"] || default_locale)
  end

  defp set_locale(conn, locale) do
    IO.inspect(locale, label: "Setting locale")

    if locale in @locales do
      Gettext.put_locale(BaselinePhoenixWeb.Gettext, locale)

      conn
      |> put_resp_cookie("locale", locale, max_age: :timer.hours(24) * 365)
      |> assign(:locale, locale)
    else
      # Log invalid locale
      IO.inspect(locale, label: "Invalid locale provided")
      # No changes made to the locale if it's not valid
      conn
    end
  end
end
