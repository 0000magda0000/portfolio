class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(:name).reverse
  end

  def show
    @project = Project.find(params[:id])
    @statistics = Project.includes(:languages).where(name: @project.name).pluck(:statistics)

    @statistics_hash = {}
    @project.languages.each do |language|
      @statistics_hash[language.name] = (100 * language.statistics.to_f / @statistics.sum).round(2)
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect project_path(@project)
    else
      render :new
    end
  end

  # def update
  #   @project = @project.find(params[:id])
  #   @project.
  # end

  # def destroy
  #   @project = @project.find(params[:id])
  #   @project.destroy
  # end

  private

  def project_params
    params.require(:projects).permit(:name, :website, :github_link, :first_push, :latest_push, :language_id, :contributer_id, :photo)
  end
end
