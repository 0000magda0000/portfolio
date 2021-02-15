require 'json'
require 'open-uri'
require 'rubygems'
require 'excon'

Info.destroy_all
Skill.destroy_all
Contributer.destroy_all
Language.destroy_all
Project.destroy_all
puts "Deleted all entries"

queermed_url = 'https://api.github.com/repos/clara-lupa/queermed'
queermed_serialized = open(queermed_url).read
queermed = JSON.parse(queermed_serialized)

queermed_project = Project.create!(
  name: queermed['name'],
  first_push: queermed['created_at'],
  github_link: queermed['html_url'],
  website: 'https://www.queermed.info')
puts "Created Project"

queermed_languages_url = 'https://api.github.com/repos/clara-lupa/queermed/languages'
queermed_languages_serialized = open(queermed_languages_url).read
queermed_languages = JSON.parse(queermed_languages_serialized)
queermed_languages_array = []
queermed_languages.each do |language, statistics|
  queermed_languages_array << Language.create(name: language, statistics: statistics)
end

puts "Created Languages with Statistics"

queermed_contributers_url = 'https://api.github.com/repos/clara-lupa/queermed/contributors'
queermed_contributers_url_serialized = open(queermed_contributers_url).read
queermed_contributers_parse = JSON.parse(queermed_contributers_url_serialized)
queermed_contributer_array = []

queermed_contributers_parse.each do |contributer, _value|
  queermed_contributer_array << Contributer.create!(
   name: contributer['login']
  )
end
puts "Created Contributers"

queermed_contributer_array.each do |qca|
  Info.create(
    project_id: queermed_project.id,
    contributer_id: qca.id
  )
end

puts "Created Infos"

queermed_languages_array.each do |qla|
  Skill.create(
    project_id: queermed_project.id,
    language_id: qla.id
  )
end

puts "Created Skills"
puts "CREATED QUEERMED"

instrumentalize_url = 'https://api.github.com/repos/clara-lupa/instrumentalize'
instrumentalize_serialized = open(instrumentalize_url).read
instrumentalize = JSON.parse(instrumentalize_serialized)

instrumentalize_project = Project.create!(
  name: instrumentalize['name'],
  first_push: instrumentalize['created_at'],
  github_link: 'https://github.com/users/clara-lupa/instrumentalize',
  website: 'https://instrumentalize.herokuapp.com')
puts "Created Project"

instrumentalize_languages_url = 'https://api.github.com/repos/clara-lupa/instrumentalize/languages'
instrumentalize_languages_serialized = open(instrumentalize_languages_url).read
instrumentalize_languages = JSON.parse(instrumentalize_languages_serialized)
instrumentalize_languages_array = []
instrumentalize_languages.each do |language, statistics|
  instrumentalize_languages_array << Language.create(name: language, statistics: statistics)
end
puts "Created Languages with Statistics"

instrumentalize_contributers_url = 'https://api.github.com/repos/clara-lupa/instrumentalize/contributors'
instrumentalize_contributers_url_serialized = open(instrumentalize_contributers_url).read
instrumentalize_contributers_parse = JSON.parse(instrumentalize_contributers_url_serialized)
instrumentalize_contributers_parse_count = instrumentalize_contributers_parse.count
instrumentalize_contributer_array = []

instrumentalize_contributers_parse.each do |contributer, _value|
  instrumentalize_contributer_array << Contributer.create!(
    name: contributer['login']
  )
end
puts "Created Contributers"

instrumentalize_contributer_array.each do |ica|
  Info.create(
    project_id: instrumentalize_project.id,
    contributer_id: ica.id
  )
end

puts "Created Infos"

instrumentalize_languages_array.each do |ila|
  Skill.create(
    project_id: instrumentalize_project.id,
    language_id: ila.id
  )
end


puts "Created Skills"
puts "CREATED INSTRUMENTALIZE"

portfolio_url = 'https://api.github.com/repos/0000magda0000/portfolio'
portfolio_serialized = open(portfolio_url).read
portfolio = JSON.parse(portfolio_serialized)

portfolio_project = Project.create!(
  name: portfolio['name'],
  first_push: portfolio['created_at'],
  github_link: portfolio['html_url'],
  website: 'https://www.portfolio.info')
puts "Created Project"

portfolio_languages_url = 'https://api.github.com/repos/0000magda0000/portfolio/languages'
portfolio_languages_serialized = open(portfolio_languages_url).read
portfolio_languages = JSON.parse(portfolio_languages_serialized)
portfolio_languages_array = []
portfolio_languages.each do |language, statistics|
  portfolio_languages_array << Language.create(name: language, statistics: statistics)
end

puts "Created Languages with Statistics"

portfolio_contributers_url = 'https://api.github.com/repos/0000magda0000/portfolio/contributors'
portfolio_contributers_url_serialized = open(portfolio_contributers_url).read
portfolio_contributers_parse = JSON.parse(portfolio_contributers_url_serialized)
portfolio_contributer_array = []


portfolio_contributers_parse.each do |contributer, _value|
portfolio_contributer_array <<  Contributer.create!(
      name: contributer['login']
    )
end
portfolio_contributors_count = portfolio_contributers_parse.count
puts "Created Contributers"

portfolio_contributer_array.each do |pca|
  Info.create(
    project_id: portfolio_project.id,
    contributer_id: pca.id
  )
end
puts "Created Infos"

portfolio_languages_array.each do |pla|
  Skill.create(
    project_id: portfolio_project.id,
    language_id: pla.id
  )
end

puts "Created Skills"
puts "CREATED PORTFOLIO"

