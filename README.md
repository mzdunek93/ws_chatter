# WsChatter

WsChatter is a WebSocket-based gem for Ruby on Rails which lets you easily add a chat functionality
to your application. WsChatter requires [Warden](https://github.com/hassox/warden) for authentication.
The simplest way to use Warden in your application is to install devise and create a User model, which
automatically gets used by WsChatter.

# Installation

Run `rails generate ws_chatter:install` to create the initializer, migration adding status column
to the user model and migration creating the message model. Three options are available:

`--scope SCOPE` changes the warden scope and the user model that the authentication is performed on. Default: `user`

`--status-column STATUS_COLUMN` changes the name of the column on the user model where the boolean value
representing whether the user is online is stored. Default: `online`

`--messages MESSAGES` name of the model in which the messages are stored. Default: `message`

Run `rake db:migrate` after running the generator.

# Javascript API

On the client side, you connect to the chat backend with the following code:

```js

var onmessage = function(id, message, time) {
  // insert code here...
}

var onconnection = function(id, message, time) {
  // insert code here...
}

var chatter = new WsChatter(onmessage, onconnection)

```

Where `onmessage()` is a handler which gets called after receiving a new message and receives the id
of the user sending the message, the message body and the time of creation. `onconnection()` gets called
when a connection with another user on the server gets created/destroyed to inform the user of the change of status.

You can use the following functions during the run of the application:

```js
chatter.send(user_id, message)

chatter.read(user_id)

chatter.close()
```

`chatter.send()` sends the message to the user with a given id, `chatter.read()` marks all the messages
from a given user as read, and `chatter.close()` closes the connection.

# License

MIT License.
