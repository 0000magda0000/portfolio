class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    statistics = []


    @projects.each do |project|
      statistics << Project
      .includes(:languages)
      .where(name: project.name)
      .pluck(:statistics, :name)
    end
    statistics = statistics.flatten.each_slice(2).to_a
    statistics_by_language = {}
    statistics.each do |statistic|
        statistics_by_language[statistic[0]] = statistic[1]
    end
    statistics_sums = {}
    @statistics_converted = statistics_by_language.keys.group_by{|k| statistics_by_language[k] }
    @statistics_converted.each do |language, statistics|
      statistics_sums[language] = statistics.sum
    end

    @statistics_by_language_project = {}
    Language.all.zip(statistics_by_language).each do |language, (statistic, project)|
      @statistics_by_language_project[statistic] = [language.name, project]
    end
    
    @statistics_hash = {}
    statistics_sums.each do |projectname, sum|
      @statistics_by_language_project.each do |statistic, names|
        if names[1] == projectname && names[0] != "WordPress"
          @statistics_hash[(100 * statistic.to_f / sum).round(2)] = [projectname, names[0]]
        end
      end
    end
  end

  def show
    @project = Project.find(params[:id])
    @statistics = Project
      .includes(:languages)
      .where(name: @project.name)
      .pluck(:statistics)

    @statistics_hash = {}
    @proj_langs = @project.languages.reject{ |lang| lang.name == 'WordPress'}
    @proj_langs.each do |language|
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
