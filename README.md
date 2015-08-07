# Todo App

An example To Do app using Webmachine. An account needs to be created by an
admin but an account can create, delete, update, and view activities.

## Requirements

- Install Vagrant. See http://docs.vagrantup.com/v2/installation/index.html
and download here: http://www.vagrantup.com/downloads.
- Install Virtualbox. See https://www.virtualbox.org/wiki/Downloads.

## Getting Started

**Connect to the guest machine**
- Run `vagrant up` on the host machine.
- Use `vagrant ssh` to visit the guest machine.
- Change directories to the project folder: `cd /vagrant`.

**Setup the app**
- Run `bundle install`.
- Create the database `createdb "todo"`.
- Setup the database: `env TODO_DATABASE=todo rake setup_database`.
- Create an account:  `env TODO_DATABASE=todo rake setup_account ACCOUNT_NAME=name
   ACCOUNT_PASSWORD=yeah`.

**Run the app**
- Run the server:     `env TODO_DATABASE=TODO rake run`.

You can now visit `http://localhost:8080/` on your host machine to interact 
with the app.

## Running the tests

First connect to the guest machine and setup the app.

**Running the tests**
- Create the test database `createdb "todo_test"`.
- Run `env TODO_DATABASE=todo_test rake`.
