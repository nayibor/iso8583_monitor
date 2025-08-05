# Iso8583Monitor


This application is a system for montoring iso8583 transactions in real time,tagging them and viewing their status in real time on web browsers.

This system receives iso 8583 messages from diverse sources on  a tcp-ip server which is also called an interface server in financial transaction processing.

it then passes the message through a filter using rules written in lua via the excellent [luerl](https://github.com/rvirding/luerl) erlang package

Filtered messages which are colour tagged are then sent through phoenix live view to the  various user browsers where the  transactions can be viewed. 

The purpose of this application is to receive real time feedback on status of transactions so that quick actions can be taken as opposed to polling of the database or other non real time means of monitoring.


##Components##

Backend web application/mis system for:

* creating,reading,updating users
* for creating rules which represent a filter for messages
* for creating endpoints which receive transactions

Tcp Server for 

* receiving and parsing iso messages
* pass message through rule system to find if message matches rule .eg. is it a decline,balance enquiry,etc..
* forwarding messages to outbound channel

Web application,rule engine and tcp server built using below:
* [phoenix](https://www.phoenixframework.org/) elixir web framework
* [ranch](https://github.com/ninenines/ranch) erlang socket library 
* [luerl](https://github.com/rvirding/luerl) erlang lua library 
* [iso8583_erl](https://github.com/nayibor/iso8583_erl.git) erlang iso8583 message parser

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
