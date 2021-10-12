

# Process Monitor

Used to check wether  the Process up or not, across the servers.

## Usage
to check the stats of the current server only
``
sh app_stat.sh
``

to check the stats of all the listed servers in cofiguration
``
sh app_stat.sh all
``

## Configuration
* PRODUCT_USER : username in which the process started 
* APP_PROCESS : here you have to configure the process names to be checked, you can add process in the following way
	* "Display Name":"grep string",<"Display Name">:<"grep string">
	or
	* "Process Name"
* hosts : you have to configure the remote hosts which you need to check as comma serperated
	* username@hostname/ip:check script location in remote dir


