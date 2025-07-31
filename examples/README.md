this folder contains sample configuration files to be used for importing configuration data.

the custom_json.cfg file can be used in the specification field when defining a new interface server on the web interface.

the custom.cfg can be used if you want to test the iso8583 parser in the console and want a sample configuration file for testing.

it can be loaded using the code sample below.

``specification = :iso8583_erl.load_specification("examples/custom.cfg")`` 
