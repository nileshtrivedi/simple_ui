defmodule SimpleUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_ui,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ash, "~> 3.4.20"},
      {:spark, "~> 2.2.30"}
    ]
  end
end
