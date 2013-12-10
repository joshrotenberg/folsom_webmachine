-module(folsom_webmachine).
-export([start/0, start_link/0, stop/0]).

ensure_started(App) ->
        case application:start(App) of
        ok ->
		ok;
	            {error, {already_started, App}} ->
            ok
    end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module,
                        webmachine_logger),
    ensure_started(folsom),
    ensure_started(webmachine),
    folsom_webmachine_sup:start_link().

%% @spec start() -> ok
%% @doc Start the folsom_webmachine server.
start() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module,
			webmachine_logger),
    ensure_started(folsom),
    ensure_started(webmachine),
    application:start(folsom_webmachine).

%% @spec stop() -> ok
%% @doc Stop the folsom_webmachine server.
stop() ->
    Res = application:stop(folsom_webmachine),
    application:stop(folsom),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(crypto),
    application:stop(inets),
    Res.
