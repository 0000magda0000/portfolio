class InfosController < ApplicationController
  def index
    @infos = Info.all
    @contributers = Contributer.all
    @projects = Project.all
  end

  def show
    @contributer = Contributer.where(name: Contributer.find(params[:id]).name)
    @contr = []
    @contributer.each do |c|
     @contr << c.name
    end
    @contr = @contr.uniq
  end
end

