# _resourceful
### Made in collaboration with [DeianGG](https://github.com/DeianGG)

## Description

&nbsp;The script is made entirely in **bash** and built specifically for Ubuntu and similar distros and it is intended to be used in the CLI. It uses 2 packages for analyzing the system resources.
The script creates a history file where each time a user runs the script it automatically logs histoic usage data. Based on the current and last 2 dates the script prompts a graph showing memory usage
and CPU usage. The script has numerous error handling functions and it is built to be light weight and portable.

## How to run?

* Install or copy the code in a .sh file.
* Open the terminal
* Run `$resourceful.sh` or the name of the file in which you copied the code.
* Make the file an executable( if you are not sure how just run `$chmod 777 resourceful.sh` or the name of your file).
* Run the script with the command `$./resourceful.sh` or the name of your file.
* The script will prompt a few installations, enter **Y** for each one, otherwise the script won't work.
* Now the script has created in your **current directory** a new directory named **resourceful** this contains:
    * a history file which logs the resources every time you run it
    * the script
* Now you can run the script again :)
  
## The information provided by the script
