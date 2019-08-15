# README

Simplified analogue of the site stackoverflow.com having the following features: 
- ask questions on issues of interest,
- give answers,
- vote for the answer,
- attach files to questions and answers (ActiveStorage, storage in the Amazon cloud),
- authenticate with third party services (GitHub, Vkontakte)
- to carry out full-text search in content (Sphinx),
- to carry out mailing using background tasks(ActiveJob),
- REST API. 

Full test coverage (TDD/BDD, Capybara, RSpec)
Used gems: devise, slim-rails, cancancan, OmniAuth
