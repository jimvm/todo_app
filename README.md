# Todo App

An example To Do app using Webmachine. An account needs to be created by an
admin but an account can create, delete, update, and view activities.

## Requirements

- Install Vagrant. See http://docs.vagrantup.com/v2/installation/index.html
and download here: http://www.vagrantup.com/downloads.
- Install Virtualbox. See https://www.virtualbox.org/wiki/Downloads.

## Getting Started

**Connect to the guest machine**
1. Run `vagrant up` on the host machine.
2. Use `vagrant ssh` to visit the guest machine.
3. Change directories to the project folder: `cd /vagrant`.

**Setup the app**
4. Run `bundle install`.
5. Create the database `createdb "todo"`.
6. Setup the database: `env TODO_DATABASE=todo rake setup_database`.
7. Create an account:  `env TODO_DATABASE=todo rake setup_account ACCOUNT_NAME=name
   ACCOUNT_PASSWORD=yeah`.

**Run the app**
8. Run the server:     `env TODO_DATABASE=TODO rake run`.

You can now visit `http://localhost:8080/` on your host machine to interact 
with the app.

## Running the tests

First connect to the guest machine and setup the app.

**Running the tests**
1. Create the test database `createdb "todo_test"`.
2. Run `env TODO_DATABASE=todo_test rake`.
