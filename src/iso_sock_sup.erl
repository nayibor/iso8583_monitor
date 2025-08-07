%%%-------------------------------------------------------------------
%% @doc iso_sock  top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(iso_sock_sup).
-behaviour(supervisor).


-export([start_link/1]).
-export([init/1,child_spec/1]).


start_link(Init_data) ->
	Pool_name = proplists:get_value(pool_name, Init_data),
    supervisor:start_link({local,Pool_name}, ?MODULE,Init_data).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init(Init_data) ->
    Worker_data = proplists:get_value(worker_data, Init_data),
    Pool_size = proplists:get_value(pool_size, Init_data),
	Children = empty_listeners(Pool_size,Worker_data),
    SupFlags = #{strategy => one_for_one,
                 intensity => 60,
                 period => 3600},
    {ok, {SupFlags, Children}}.	
	
%% internal functions

child_spec(Worker_data) ->
#{id => monitor_iso_client,start => {iso_genst, start_link,[Worker_data]},
		restart => permanent,shutdown => 1000,type => worker,modules => [iso_genst]}.       
% mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()} 

empty_listeners(Num_children,Worker_data) ->
    [child_spec(Worker_data) || _ <- lists:seq(1,Num_children)].
