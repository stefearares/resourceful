# >resourceful
### Made in collaboration with [DeianGG](https://github.com/DeianGG)

## Description

&nbsp;The script is made entirely in **bash** and built specifically for Ubuntu and similar Debian based distros and it is intended to be used in the CLI. 
It uses 2 packages for analyzing the system resources.
The script creates a history file where each time a user runs the script it automatically logs historic usage data. Based on the current and last 2 dates the script prompts a graph showing memory usage
and CPU usage. 
The script has numerous error handling functions and it is built to be light weight and portable.

## How to run?

* Install or copy the code in a .sh file.
* Open the terminal.
* Make the file an executable( if you are not sure how just run `$chmod 777 resourceful.sh` or the name of your file).
* Run the script with the command `$./resourceful.sh` or the name of your file.
* The script will prompt a few installations, enter **Y** for each one, otherwise the script won't work.
* Now the script has created in your **current directory** a new directory named **resourceful** that contains:
    * a **history** file which logs the resources every time you run it
    * the script
* Now you can run the script again. :)
  
## The information provided by the script

* The name of the user who ran the script.
* CPU usage (colored depending on how much is used: green for low, yellow for medium and red for high).
* Memory usage (colored the same way CPU usage is colored) and how much available memory is left.
* Network information (ping, upload and download speed, if available).
* Number of manually installed packages.
* I/O devices such as an SSD or HDD(both of which appear only if available).

## The Graph

&nbsp;The script shows on each run two different graphs. These graphs are the CPU usage and the Memory usage graphs.

Each part of the graph has 3 types of states as seen in the image below:

![Usage graph](DOCUMENTATION/usage_graph.png)


