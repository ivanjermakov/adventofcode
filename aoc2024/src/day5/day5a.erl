-module(day5a).
-export([main/0]).

input(Path) ->
    case file:read_file(Path) of
        {ok, Binary} ->
            binary_to_list(Binary);
        {error, Reason} ->
            io:format(Reason),
            halt()
    end.

parse(Input) ->
    [RulesStr, PagesStr] = string:split(Input, "\n\n"),
    {Rules, PagesList} = {string:split(RulesStr, "\n", all), string:split(PagesStr, "\n", all)},
    {
        sets:from_list(Rules),
        lists:map(
            fun(Pages) -> lists:map(
                fun(N) -> list_to_integer(N) end,
                string:split(Pages, ",", all)
            ) end,
            lists:filter(
                fun(L) -> L =/= [] end,
                PagesList
            )
        )
    }.

valid_pages(Pages, Rules) ->
    Cmp = fun(A, B) -> sets:is_element(io_lib:format("~B|~B", [A, B]), Rules) end,
    Sorted = lists:sort(Cmp, Pages),
    Pages == Sorted.

main() ->
    Input = input("data/day5.txt"),
    {Rules, PagesList} = parse(Input),
    ValidLists = lists:filter(fun(Pages) -> valid_pages(Pages, Rules) end, PagesList),
    Result = lists:sum(lists:map(fun(L) -> lists:nth(ceil(length(L) / 2), L) end, ValidLists)),
    io:format("~B~n", [Result]),
    halt().

