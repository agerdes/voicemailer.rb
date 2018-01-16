# voicemailer.rb
Voicemail-to-email and SMS-to-email, backed by Twilio.

## Here for a work sample?
Thanks for taking a look at my code! This project sends SMS and voicemails from my US phone number to my email while I'm traveling abroad.

### Design goals for this project 
1. Include no persistent state so that it may be run redundantly in multiple environments
2. Simple configuration via a YAML file
