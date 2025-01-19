# Mocks
[
  Nebulex.Adapters.Cachex.Router,
  Cachex.Router,
  Cachex
]
|> Enum.each(&Mimic.copy/1)

# Nebulex dependency path
nbx_dep_path = Mix.Project.deps_paths()[:nebulex]

Code.require_file("#{nbx_dep_path}/test/support/fake_adapter.exs", __DIR__)
Code.require_file("#{nbx_dep_path}/test/support/cache_case.exs", __DIR__)

for file <- File.ls!("#{nbx_dep_path}/test/shared/cache") do
  Code.require_file("#{nbx_dep_path}/test/shared/cache/" <> file, __DIR__)
end

for file <- File.ls!("#{nbx_dep_path}/test/shared"), file != "cache" do
  Code.require_file("#{nbx_dep_path}/test/shared/" <> file, __DIR__)
end

for file <- File.ls!("test/shared"), not File.dir?("test/shared/" <> file) do
  Code.require_file("./shared/" <> file, __DIR__)
end

Code.require_file("support/test_cache.exs", __DIR__)

# Start Telemetry
_ = Application.start(:telemetry)

# Set nodes
nodes = [:"node1@127.0.0.1", :"node2@127.0.0.1", :"node3@127.0.0.1"]
:ok = Application.put_env(:nebulex_distributed, :nodes, nodes)

# For tasks/generators testing
Mix.start()
Mix.shell(Mix.Shell.Process)

# Start ExUnit
ExUnit.start()
