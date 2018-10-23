# Akamai_API_scripts
Shell scripts for common Akamai Open APIs.

You need to have the following installed on your system. 

a. You need to have "jq" installed. -> http://macappstore.org/jq/

b. You need to have HTTPie installed. -> https://brewinstall.org/Install-httpie-on-Mac-with-Brew/ (use Brew for installation, this is usually seamless)

c. You need to have your edgegrid file set up as below 

   Have a section [default] where you need to have your credentials for account switching. 
   
   Have a section for purge as [purge], where you will have your purge credentials
   
   In your ~/.httpie/config.json you need to edit the json as 
   
   {
    "__meta__": {
        "about": "HTTPie configuration file",
        "help": "https://httpie.org/docs#config",
        "httpie": "0.9.9"
    },
    "default_options": ["--auth-type=edgegrid","-a=default:"]
}

d. Now download the entire folder, PAPI or PURGE(as per you choice, the sh files need to be in the same folder as the json files )

e. change directory to PAPI or PURGE and use ./(script name) to run. 

f. You should be good !!


