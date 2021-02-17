class LanguagesController < ApplicationController

  def index
    @languages = Language.all
    @skills = Skill.all
    @projects = Project.all
    @language_stats = Language.group(:name).calculate(:sum, :statistics)
    sum = @language_stats.values.inject { |a, b| a + b }

    @percent = {}
    @language_stats.each do |language, value|
      @percent[language] = 100 * value / sum
    end
    @percent = @percent.sort_by { |language, value| value }.reverse
  end

  def show
    @language = Language.find(params[:id])
  end
end
