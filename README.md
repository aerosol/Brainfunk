Brainfunk
=========

An Erlang implementation of Brainfuck. Cures hangover.

License: wtfpl


```
$ rebar compile; erl -pa ebin
==> brainfunk (compile)
Compiled src/brainfunk.erl
Erlang R14B04 (erts-5.8.5) [source] [64-bit] [smp:4:4] [rq:4] [async-threads:0] [hipe] [kernel-poll:false]

Eshell V5.8.5  (abort with ^G)
1> brainfunk:source("helloworld.brainfuck").
Hello World!
ok
2>
```



