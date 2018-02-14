defmodule WarEngine.Mixfile do
  use Mix.Project

  def project do
    [
      app: :war_engine,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
  # Docs
   name: "WarEngine",
   source_url: "https://github.com/EssenceOfChaos/war_engine",
   homepage_url: "",
   docs: [main: "WarEngine", # The main page in the docs
          logo: "assets/images/war-icon.png",
          extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WarEngine.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}    
    ]
  end
end
