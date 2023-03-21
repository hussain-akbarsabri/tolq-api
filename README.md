# Tolq
  Translator API - An API with several endpoints to manage glossaries and translations

# Models
  - Glossary
  - LanguageCode
  - Term
  - Translation

# Gems
  - active_model_serializers
  - dotenv-rails
  - simplecov
  - shoulda-matchers

# System dependencies
  - Rails 7.0.4
  - Ruby 2.7.7

# Setup Instructions
  - Unzip the project
  - Install docker and docker-compose if it is not installed already (https://docs.docker.com/desktop/install/mac-install/)
  - Run your docke-deamon
  - Run docker-compose build
  - Run docker-compose up
  - Add your environment variables in .env file
    - POSTGRES_HOST, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_PORT
  - go to http://localhost:3000/
