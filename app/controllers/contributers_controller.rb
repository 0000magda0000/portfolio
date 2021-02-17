class ContributersController < ApplicationController
  def index

  end

  def show
    @contributer = Contributer.find(params[:id])
    @contributer_details = Contributer.where(name: @contributer.name)

    @contributer_projects = []
    @contributer_details.each do |condet|
      condet.projects.each do |cd|
        @contributer_projects << cd.name
      end
    end


    @infos = Info.all
  end
end
