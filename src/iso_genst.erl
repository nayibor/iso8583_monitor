-module(iso_genst).
-behavior(gen_statem).


-export([start_link/1,request/2]).
-export([callback_mode/0,init/1,terminate/3,code_change/4]).
-export([disconnected/3, connected/3]).



%%public api
start_link(Opts) ->
    Host = proplists:get_value(server_address, Opts),
    Port = proplists:get_value(server_port, Opts),
    Init_options = proplists:get_value(init_options, Opts),
    Bheader = proplists:get_value(bhead, Init_options),
    Specification = proplists:get_value(spec_iso, Init_options),
    Backoff = proplists:get_value(backoff, Init_options), 
    gen_statem:start_link(?MODULE, {Host, Port,Bheader,Specification,Backoff}, []).


request(Pid, Request) ->
    gen_statem:call(Pid, {request, Request}).


%%callbacks
callback_mode() -> state_functions.


init({Host, Port,Bheader,Specification,Backoff}) ->
    Data = #{host => Host, port => Port,socket => error,bhead => Bheader, spec_iso => Specification,
    def_backoff => Backoff,backoff => Backoff,iso_message => []},
    Actions = [{next_event, internal, connect}],
    {ok, disconnected, Data, Actions}.


terminate(_Reason, _State, _Data) ->
    ok.


code_change(_Vsn, State, Data, _Extra) ->
    {ok,State,Data}.


%%disconnected state and various transition events
%%event to connect internally when in  disconnected state
disconnected(internal, connect, #{host := Host, port := Port,backoff := Backoff,def_backoff := Defbackoff} = Data) ->
    case gen_tcp:connect(Host, Port, [list, {active, once}]) of
        {ok, Socket} ->
            Data1 = maps:put(socket, Socket, Data),
            {next_state, connected,Data1#{backoff := Defbackoff}};
        {error, Error} ->
            error_logger:format("Connection failed: ~ts~n", [inet:format_error(Error)]),
			Actions = [{{timeout, reconnect}, Backoff, undefined}],
			Newbackoff = backoff:rand_increment(Backoff),
			{keep_state,Data#{backoff := Newbackoff},Actions}
    end;

disconnected({timeout, reconnect}, _, Data) ->
    Actions = [{next_event, internal, connect}],
    {keep_state, Data, Actions};


%%when a request is made when in the disconnected state
%%reply is sent that i disconected
disconnected({call, From}, {request, _}, _Data) ->
    Actions = [{reply, From, {error, disconnected}}],
    {keep_state_and_data, Actions};



%%disconnected state  but when event is received about death of genserver
disconnected(info,{'EXIT', _Pid, _Reason},State) ->
	{keep_state, State, []}.


%%disconnected state  but when event is received about death of genserver
connected(info,{'EXIT', _Pid, _Reason},State) ->
	{keep_state, State, []};


%%connected state and various transition events
%%connected state and receives tcp close event
connected(info, {tcp_closed, _Socket},Data) ->
	disconnect_realtime(Data);


%%connected state and various transition events
%%connected state and receives tcp error event
connected(info, {tcp_error, _Socket},Data) ->
	disconnect_realtime(Data);


%%connected state which is receiving information on socket
connected(info, {tcp, Socket, Iso_message}, #{socket := Socket} = Data) ->
		try process_transaction(Iso_message,Data) of
	        Data1 ->
				ok = inet:setopts(Socket, [{active, once}]),
				{keep_state, Data1}
		catch Class:Reason:Stacktrace ->
			%%error message has to marshalled here and sent back to sender at this point 
			%%%all of message may not have been streamed in so in the meantime a return message should be formated and sent back to sender
			error_logger:error_msg("~nClass ~p~nReason ~p~nStacktrace ~p",[Class, Reason, Stacktrace]),
		    {stop,error, Data}
		end;


%%when a request is made when in the connected  state
%%request is accepted,what needs to be done is done and response sent back
%%this generally wont be focus of program since program is mainly internal
connected({call, From}, {request, _Request}, _Data) ->
	    Actions = [{reply, From, {error,fuckoff}}],
	    {keep_state_and_data, Actions}.


%%remove cache of request and inform all clients of disconnects 
%%will be sent only once depending on if there is an error,closed socket,
disconnect_realtime(#{socket := Socket} = Data)->
    io:format("Connection closed~n"),
    ok = gen_tcp:close(Socket),
    Actions = [{next_event, internal, connect}],	
    {next_state, disconnected, Data,Actions}.  


%% @doc this is for processing the transactions which come through the system 
%%process_transaction({_tcp,_Port_Numb,Msg}, S = #state{socket=AcceptSocket,iso_message=Isom,transport=Transport,event_handler=Epid,bhead=Bheader})->
%%have to add something which checks the maximum size of a field
process_transaction(Msg, S = #{socket := _AcceptSocket,iso_message := Isom,bhead := Bheader,spec_iso := Specification})->
		State_new = lists:flatten([Isom,Msg]), 
		%%io:format("~n raw client message is ~p", [Msg]),		
		case length(State_new) of 
			Size when Size < Bheader -> 
				S#{iso_message := State_new};
			_  ->
				{LenStr, Rest} = lists:split(Bheader, State_new),
				Len = erlang:list_to_integer(LenStr),
				case erlang:length(Rest) of 
					SizeafterHead when Len =:= SizeafterHead ->	
						io:format("~n main message is ~p~n", [Rest]),
						Map_iso = iso8583_erl:unpack(Rest,Specification),
						io:format("~n message map received is ~p~n", [Map_iso]),
						S#{iso_message := []};
						%%io:format("~n aftprocess  client message is ~p~n", [Response_process]),
						%case Response_process of
							%{error,Reason}->
								%Final_size = iso8583_erl:get_size_send(Reason,Bheader),
								%Final_socket_err_resp = [Final_size,Reason],
								%ok = send(AcceptSocket,Final_socket_err_resp),	
								%S#{iso_message := []};
							%{ok,Iso_Response} ->
								%Final_size = iso8583_erl:get_size_send(Iso_Response,Bheader),
								%Final_socket_response = [Final_size,Iso_Response],
								%ok = send(AcceptSocket,Final_socket_response),
								%S#{iso_message := []};
							%ok ->
								%S#{iso_message := []}
						%end;
					SizeafterHead when Len < SizeafterHead ->
						S#{iso_message := State_new}
				end
		end.


%% @doc for sending information through the socket
-spec send(port(),[pos_integer()])->ok|{error,any()}.
send(Socket, Str) ->
		ok = gen_tcp:send(Socket,Str).
