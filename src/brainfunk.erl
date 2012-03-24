%%                  DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
%%                           Version 2, December 2004
%%
%%               Copyright (C) 2012 Adam Rutkowski <adam@mtod.org>
%%
%%       Everyone is permitted to copy and distribute verbatim or modified
%%      copies of this license document, and changing it is allowed as long
%%                            as the name is changed.
%%
%%                  DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
%%        TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
%%
%%                   0. You just DO WHAT THE FUCK YOU WANT TO.

-module(brainfunk).
-author('adam <hq@mtod.org>').
-export([source/1, fuck/1]).

-define(CELLS, <<0:(8*30000)>>).

fuck(<<">", Pending/binary>>, P, C) ->
    fuck(Pending, P+1, C);
fuck(<<"<", Pending/binary>>, P, C) ->
    fuck(Pending, P-1, C);
fuck(<<"+", Pending/binary>>, P, C) ->
    <<Left:P/binary, Cell/integer, Right/binary>> = C,
    NewC = <<Left/binary, (Cell+1)/integer, Right/binary>>,
    fuck(Pending, P, NewC);
fuck(<<"-", Pending/binary>>, P, C) ->
    <<Left:P/binary, Cell/integer, Right/binary>> = C,
    NewC = <<Left/binary, (Cell-1)/integer, Right/binary>>,
    fuck(Pending, P, NewC);
fuck(<<".", Pending/binary>>, P, C) ->
    <<_:P/binary, Cell:8, _/binary>> = C,
    io:format([Cell]),
    fuck(Pending, P, C);
fuck(<<",", Pending/binary>>, P, C) ->
    <<Left:P/binary, _:8, Right/binary>> = C,
    fuck(Pending, P, <<Left, case io:get_chars("", 1) of
                                    [C] -> C;
                                    eof -> 0
                                end, Right>>);
fuck(<<"[", Pending/binary>>, P, C) ->
    {Pos, 1} = binary:match(Pending, <<"]">>),
    <<Loop:Pos/binary, LoopPending/binary>> = Pending,
    <<_:(P)/binary, Cell/integer, _/binary>> = C,
    case Cell of
        0 ->
            fuck(LoopPending, P, C);
        _ ->
            {NewP, NewC} = fuck(Loop, P, C),
            fuck(<<"[", Loop/binary, "]", LoopPending/binary>>, NewP, NewC)
    end;
fuck(<<_, Pending/binary>>, P, C) ->
    fuck(Pending, P, C);
fuck(<<>>, P, C) ->
    {P, C}.
fuck(Program) ->
    fuck(Program, 0, ?CELLS).

source(File) ->
    {ok, Program} = file:read_file(File),
    fuck(Program),
    ok.

