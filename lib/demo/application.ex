defmodule Demo.Application do
  use Application

  def start(_type, _args) do
    children = [{Demo.Supervisor, :implicit_arg}]
    opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Demo.Supervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def start_child(foo, bar, baz) do
    # This will start child by calling Worker.start_link(implicit_arg, foo, bar, baz)
    spec = Supervisor.Spec.worker(Demo.Worker, [foo, bar, baz])
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(implicit_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [implicit_arg]
    )
  end
end

defmodule Demo.Worker do
  use GenServer

  require Logger

  def start_link(:implicit_arg, :foo, :bar, :baz) do
    GenServer.start_link(__MODULE__, [:implicit_arg, :foo, :bar, :baz])
  end

  def init(:implicit_arg, :foo, :bar, :baz) do
    {:ok, []}
  end

  def handle_call(request, from, state) do
    Logger.debug(fn -> "#{request} from #{from}" end)
    {:reply, :ok, state}
  end
end
