# Demo

Demo to demonstrate a potential bug in `Elixir.DynamicSupervisor`. 
Run the following to reproduce:

```bash
$ iex -S mix
iex> Application.ensure_all_started(:sasl)
iex> Demo.Supervisor.start_child(:foo, :bar, :baz)
iex> Demo.Supervisor.start_child(:foo, :bar, :baz)
iex> {:ok, pid} = Demo.Supervisor.start_child(:foo, :bar, :baz)
iex> Supervisor.which_children(Demo.Application.Supervisor)
iex> Supervisor.which_children(Demo.Supervisor)
iex> Process.exit(pid, :kill)
```
