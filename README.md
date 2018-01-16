# voicemailer.rb
Voicemail-to-email and SMS-to-email, backed by Twilio.

## Here for a work sample?
Thanks for taking a look at my code! This project sends SMS and voicemails from my US phone number to my email while I'm traveling abroad.

### Design goals for this project
:white_check_mark: Include no persistent state so that it may be run redundantly in multiple environments

:white_check_mark: Simple configuration via a YAML file

:white_check_mark: Easy-to-test core libraries and appropriate test suite



## Getting Started
Voicemailer.rb requires Ruby 2.3.0+, Twilio API credentials, and an SMTP gateway (you can use your Gmail account).

* [Local Installation](#local-installation)
* [Running Tests](#running-tests)


## Local Installation

From your command-line:

```
git clone git@github.com:agerdes/voicemailer.rb.git
cd voicemailer.rb
bundle install
```


## Running Tests

The following command runs the test suite:

```
rake test
```

If all assertions run with no failures, you've successfully installed the project to your local environment!


(c) Aaron Gerdes. All rights reserved.