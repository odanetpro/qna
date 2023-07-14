# README

QnA (Questions and Answers) implements some ideas of Stackoverflow. 
Developed on RoR using TDD/BDD.

Features:
* Ask questions and give answers
* Comment questions and answers
* Attach files and links to questions and answers
* Vote for questions and answers,
* Q&A rating
* Choosing the best answer
* Best answer award
* Sending a list of new questions for the last 24 hours for registered users
* Subscribe/unsubscribe to question's updates 

Technologies and dependencies:
* Ruby 3.0.3, Rails 6.1.7, PostgreSQL, Slim, Bootstrap
* Devise + OmnyAuth authentication (via Githab, Vkontakte providers)
* Authorization CanCanCan
* Direct upload files on YandexCloud
* Load gist content using gh3 (client-side js API wrapper for GitHub)
* Create/update questions and answers with Ajax
* Updating questions list, and answers for question via ActionCable
* Background tasks with ActiveJob, Sidekiq and Redis
* Sphinx search
* Fragment caching

API:
* Doorkeep authorization
* Resources:
  * /api/v1/profiles/me - about me
  * /api/v1/questions/ - questions list
  * /api/v1/questions/:question_id/answers - answers for question

Tests:
* Rspec, Shoulda-Matchers, FactoryBot, Capybara

Deploy:
* Capistrano
