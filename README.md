># Here for a work sample?
>Thanks for taking a look at my code! This project sends SMS and voicemails from my US phone numbers to my email while I'm traveling abroad.
>
>
>## Design goals for this project
>:white_check_mark: Handle multiple phone numbers per installation via simple configuration
>
>:white_check_mark: Include no persistent state for easy redundancy by running multiple environments round-robin-style
>
>:white_check_mark: Easy-to-test core libraries and appropriate test suite
>
>:white_check_mark: Authenticate all API traffic from Twilio
>
> 
>## Where to start
>* [app.rb](app.rb) is the core controller, handling incoming requests from Twilio, authenticating requests, and routing behavior based on the appropriate phone number
>* [lib/response.rb](lib/response.rb) generates TwiML, Twilio's XML instruction set for answering calls, requiring number keys ("press 5 to leave a message"), and recording audio. The Response.build method handles the boilerplate for generating TwiML, while the other methods are called from [app.rb](app.rb)
>* [The test suite](test/) covers success and failure cases of the app's functionality and includes helpers to mock Twilio's request-signing functionality.


# voicemailer.rb
Voicemail-to-email and SMS-to-email, backed by Twilio.


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


Copyright (c) Aaron Gerdes. All rights reserved.
