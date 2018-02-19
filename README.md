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

Complete `iex` session log:

```
$ iex -S mix
Erlang/OTP 20 [erts-9.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.6.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Application.ensure_all_started(:sasl)

=PROGRESS REPORT==== 19-Feb-2018::20:05:59 ===
          supervisor: {local,sasl_safe_sup}
             started: [{pid,<0.124.0>},
                       {id,alarm_handler},
                       {mfargs,{alarm_handler,start_link,[]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=PROGRESS REPORT==== 19-Feb-2018::20:05:59 ===
          supervisor: {local,sasl_sup}
             started: [{pid,<0.123.0>},
                       {id,sasl_safe_sup},
                       {mfargs,
                           {supervisor,start_link,
                               [{local,sasl_safe_sup},sasl,safe]}},
                       {restart_type,permanent},
                       {shutdown,infinity},
                       {child_type,supervisor}]

=PROGRESS REPORT==== 19-Feb-2018::20:05:59 ===
          supervisor: {local,sasl_sup}
             started: [{pid,<0.125.0>},
                       {id,release_handler},
                       {mfargs,{release_handler,start_link,[]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=PROGRESS REPORT==== 19-Feb-2018::20:05:59 ===
         application: sasl
          started_at: nonode@nohost
{:ok, [:sasl]}
iex(2)> Demo.Supervisor.start_child(:foo, :bar, :baz)
{:ok, #PID<0.128.0>}
iex(3)> Demo.Supervisor.start_child(:foo, :bar, :baz)
{:ok, #PID<0.130.0>}
iex(4)> Demo.Supervisor.start_child(:foo, :bar, :baz)
{:ok, #PID<0.132.0>}
iex(5)> Supervisor.which_children(Demo.Application.Supervisor)
[{Demo.Supervisor, #PID<0.116.0>, :supervisor, [Demo.Supervisor]}]
iex(6)> Supervisor.which_children(Demo.Supervisor)
[
  {:undefined, #PID<0.128.0>, :worker, [Demo.Worker]},
  {:undefined, #PID<0.130.0>, :worker, [Demo.Worker]},
  {:undefined, #PID<0.132.0>, :worker, [Demo.Worker]}
]
iex(7)> Process.exit(pid(0,128,0), :kill)
true
iex(8)>
=SUPERVISOR REPORT==== 19-Feb-2018::20:06:49 ===
     Supervisor: {local,'Elixir.Demo.Application.Supervisor'}
     Context:    child_terminated
     Reason:     shutdown
     Offender:   [{pid,<0.116.0>},
                  {id,'Elixir.Demo.Supervisor'},
                  {mfargs,
                      {'Elixir.Demo.Supervisor',start_link,[implicit_arg]}},
                  {restart_type,permanent},
                  {shutdown,infinity},
                  {child_type,supervisor}]


=PROGRESS REPORT==== 19-Feb-2018::20:06:49 ===
          supervisor: {local,'Elixir.Demo.Application.Supervisor'}
             started: [{pid,<0.137.0>},
                       {id,'Elixir.Demo.Supervisor'},
                       {mfargs,
                           {'Elixir.Demo.Supervisor',start_link,
                               [implicit_arg]}},
                       {restart_type,permanent},
                       {shutdown,infinity},
                       {child_type,supervisor}]
iex(8)> Supervisor.which_children(Demo.Application.Supervisor)
[{Demo.Supervisor, #PID<0.137.0>, :supervisor, [Demo.Supervisor]}]
iex(9)> Supervisor.which_children(Demo.Supervisor)
[]
iex(10)>
```
