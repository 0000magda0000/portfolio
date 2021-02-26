require 'json'
require 'open-uri'

class AddDataServices
	def createData
		peterhanson_project = Project.create!(
		  name: "peterhansonmusic.com",
		  website: "http://peterhansonmusic.com",
		  first_push: "26th Feb 2021".to_date
		)
  		peterhanson_project.photo.attach(io: File.open('app/assets/images/peterhanson.png'), filename: 'peterhanson.png', content_type: 'image/png')


		peterhanson_languages = Language.create!(name: "WordPress")

		peterhanson_contributers = Contributer.create!(
		  name: "0000magda0000",
		  github: "https://github.com/0000magda0000"
		)

		Skill.create!(language_id: peterhanson_languages.id, project_id: peterhanson_project.id)
		Info.create!(contributer_id: peterhanson_contributers.id, project_id: peterhanson_project.id)
		puts "CREATED PETERHANSONMUSIC"
	end
end

# data = AddDataServices.new
# data.createData
