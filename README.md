# README
A simple trivia game with create, answer and maintain leader board for logged in Users.

Deployed at Url: https://trivia-asirivella.herokuapp.com/

Technologies:
  - Ruby on rails
  - PostgresSQL
  - Twitter Bootstrap basic
  
Instructions to run:
  - clone the file from github
  - run "bundle install" to install necessary installation (add --without production for development)
  - run "rake db:migrate" to get the database installed.
  - run "rails s" to start server. If found any error check on stackoverflow.
 
 Notes:
  - The app support multiple category tagging and trivia page styling differenciation of the number of questions.
  - The answer matching is done using string distance between words (is less than 4) with filtering some stop words like 'a', 'the',etc.
  - The app doesn't show the question which are created by himself.
  
 Useful links:
  - http://guides.rubyonrails.org/
  - http://railscasts.com/episodes/382-tagging?view=asciicast
  - http://railscasts.com/episodes/328-twitter-bootstrap-basics
  - http://docs.railsbridge.org/intro-to-rails/deploying_to_heroku
