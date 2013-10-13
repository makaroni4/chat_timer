# ChatTimer

Simple tool for tracking your time via Skype.

## Demo

~~~
chat_timer scan --db ~/Library/Application\ Support/Skype/USERNAME/main.db

AUTHOR: gistflow
  CHAT: ruby developers
    08:00 10/10/2013 begin     Started work on chat_timer
    08:45 10/10/2013 pause     Coffee break
    11:30 10/11/2013 continue  Making Cli interface with Thor
    12:33 10/11/2013 pause     Coffee break
    15:43 10/11/2013 stop      Beta version of chat_timer on Github!
    18:52 10/11/2013 end       Such a good day at work!
~~~

## Usage

So there are 2 types of commmands:

* starting (begin continue start)

~~~
=begin Writing User specs
~~~

* stopping (pause break stop end).

~~~
=pause Coffee break
=end Going home, it was a great day!
~~~

Also you correct command timestamp by passing hour and minute to command:

~~~
=start(14:35) User class refactoring (move friendship logic to class)
~~~

## Installation

git clone https://github.com/makaroni4/chat_timer.git
rake install
