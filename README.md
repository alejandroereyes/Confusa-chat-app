# Confusa Chat App

  This program houses the back end for Heroku chat application.

## To use Confusa

  Go to  `http://chaneyz.github.io/`

## Additional Information
  * Link to Hackpad `https://confusachatapp.hackpad.com/Confusa-tF1rQ96PePX`
  * Link to Trello `https://trello.com/b/7b12TJgO/chat-app`

## Features
  * username can be entered
  * messages from last 5 minutes are displayed
  * messages are displayed for one chatroom at a time
  * can switch between chatrooms
  * top 10 users with message rank displayed
  * recent users from the last 4 hours displayed
  * top 3 chatrooms displayed
  * a list of all chatrooms
  * swear words are filter and replced with "*"
  * bot will monitor messages and respond to "amiright", "?", and "what time is it"
  * emoticons supported

# Notes
  There are currently a list of freatures that are not supported via the web page
  * adjust message history load for current chat room time in relation to current time in seconds`http://confusa.heroku.com/confusa?room=global&start_messages=100000`
  * adjust active users shown by time `http://confusa.heroku.com/confusa/recent_users?start_time=900`
  * view a user's profile `http://confusa.heroku.com/confusa/profile?name=leo`
  * view room history `http://confusa.heroku.com/confusa/room_history?room=global&start_time=6-6-15&end_time=6-7-15`

## Details

* Ruby version 2.2.0

* System dependencies
  * faker gem
  * swearjar gem

