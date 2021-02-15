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
queermed_languages_infos = []
queermed_languages.each do |language, statistics|
  queermed_languages_infos << Language.create(name: language, statistics: statistics)
end

queermed_languages_infos_count = queermed_languages_infos.count
puts "Created Languages with Statistics"

queermed_contributers_url = 'https://api.github.com/repos/clara-lupa/queermed/contributors'
queermed_contributers_url_serialized = open(queermed_contributers_url).read
queermed_contributers_parse = JSON.parse(queermed_contributers_url_serialized)
queermed_contributer_array = []


queermed_contributers_parse.each do |contributer, _value|
    Contributer.create!(
      name: contributer['login']
    )
end
queermed_contributors_count = queermed_contributers_parse.count
puts "Created Contributers"

  Contributer.all[0..queermed_contributors_count - 1].each do |contributer|
    Info.create!(
      project_id: queermed_project.id,
      contributer_id: contributer.id
  )
end
puts "Created Infos"

Language.all[0..queermed_languages_infos_count - 1].each do |language|
  Skill.create!(
    project_id: queermed_project.id,
    language_id: language.id
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
instrumentalize_languages_infos = []
instrumentalize_languages.each do |language, statistics|
  instrumentalize_languages_infos << Language.create(name: language, statistics: statistics)
end
puts "Created Languages with Statistics"

instrumentalize_contributers_url = 'https://api.github.com/repos/clara-lupa/instrumentalize/contributors'
instrumentalize_contributers_url_serialized = open(instrumentalize_contributers_url).read
instrumentalize_contributers_parse = JSON.parse(instrumentalize_contributers_url_serialized)
instrumentalize_contributers_parse_count = instrumentalize_contributers_parse.count

instrumentalize_contributers_parse.each do |contributer, _value|
  Contributer.create!(
    name: contributer['login']
  )
end
puts "Created Contributers"

Contributer.all[queermed_contributors_count.. - 1].each do |contributer|
  Info.create!(
    project_id: instrumentalize_project.id,
    contributer_id: contributer.id
  )
end
puts "Created Infos"

Language.all[queermed_languages_infos_count.. - 1].each do |language|
  Skill.create!(
    project_id: instrumentalize_project.id,
    language_id: language.id
  )
end

puts "Created Skills"
puts "CREATED instrumentalize"
