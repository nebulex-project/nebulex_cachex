defmodule NebulexCachex.MixProject do
  use Mix.Project

  @source_url "https://github.com/nebulex-project/nebulex_cachex"
  @version "3.0.0-dev"
  # @nbx_vsn "3.0.0"

  def project do
    [
      app: :nebulex_cachex,
      version: @version,
      elixir: "~> 1.12",
      aliases: aliases(),
      deps: deps(),

      # Testing
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package(),
      description: "A Nebulex adapter for Cachex",

      # Docs
      docs: [
        main: "Nebulex.Adapters.Cachex",
        source_ref: "v#{@version}",
        source_url: @source_url
      ]
    ]
  end

  defp deps do
    [
      nebulex_dep(),
      {:nimble_options, "~> 0.5 or ~> 1.0"},
      {:cachex, "~> 4.0"},
      {:telemetry, "~> 0.4 or ~> 1.0", optional: true},

      # Test & Code Analysis
      {:excoveralls, "~> 0.18", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.7", only: :test},
      {:stream_data, "~> 1.1", only: [:dev, :test]},
      {:nebulex_distributed,
       github: "nebulex-project/nebulex_distributed", branch: "main", only: :test},

      # Benchmark Test
      {:benchee, "~> 1.3", only: [:dev, :test]},
      {:benchee_html, "~> 1.0", only: [:dev, :test]},

      # Docs
      {:ex_doc, "~> 0.36", only: [:dev, :test], runtime: false}
    ]
  end

  defp nebulex_dep do
    if path = System.get_env("NEBULEX_PATH") do
      {:nebulex, path: path, override: true}
    else
      {:nebulex, github: "cabol/nebulex", branch: "v3.0.0-dev"}
    end
  end

  defp aliases do
    [
      "nbx.setup": [
        "cmd rm -rf nebulex",
        "cmd git clone --depth 1 --branch v3.0.0-dev https://github.com/cabol/nebulex"
      ],
      check: [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "coveralls.html",
        "sobelow --exit --skip",
        "dialyzer --format short"
      ]
    ]
  end

  defp package do
    [
      name: :nebulex_cachex,
      maintainers: [
        "Carlos Bolanos",
        "Felipe Ripoll"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:nebulex],
      plt_file: {:no_warn, "priv/plts/" <> plt_file_name()},
      flags: [
        :unmatched_returns,
        :error_handling,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end

  defp plt_file_name do
    "dialyzer-#{Mix.env()}-#{System.otp_release()}-#{System.version()}.plt"
  end
end
