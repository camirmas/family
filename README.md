# FamilyFriday

> :sun_with_face: A group randomizer application built with Elixir. Slack Command ready.

This application provides an easy to use, extensible system that helps create random groups with a simple Slack Command.

### Setup

To set up the application:
1. Clone the repo
2. Make sure you have Elixir and Phoenix installed on your computer
3. `mix deps.get && iex -S mix phoenix.server`
4. Set up a new [Slack App](https://api.slack.com/apps) and have the endpoint set to `[base_url]/api/v1/friyay`. Note that you might need to set up [ngrok](https://api.slack.com/tutorials/tunneling-with-ngrok) to be able to test the interaction locally
5. Install the App for your Slack team.

### Usage

You will be able to set up the slash command with whatever name you want, but for the purposes of these docs we'll go with `/fam-friday`.

To get an existing schedule, no arguments are needed.

To add a new user, enter `/fam-friday add-fam First Last`

To create a new schedule, enter `/fam-friday schedule`

### Design

The application design consists of an Elixir umbrella application with 3 child apps:
- A Phoenix API layer, that handles requests and delegates work to the other applications
- A User application that manages users with a combination of an ETS table and CSV
- A Scheduler that provides the logic for creating groups

On startup, the User application loads all entries from the CSV and places them into an ETS table. Other applications will use this ETS table to access user data. When a new user is added, the information is both appended to the CSV as well as added to the ETS table. An example CSV file lives in `/apps/user/lib/user/users.csv`. Entries consist of 3 columns: a UUID, a First Name, and a Last Name. Feel free to modify this file to provide your own user information.

The Scheduler takes user data, splits users into groups of 3, 4, or 5. It takes as many groups of 3 as possible, and fills in extra spots as necessary.

### Further considerations

Make group sizes configurable.
Enhance the scheduler to provide a cron that makes a new schedule on an interval, say, once a month.
