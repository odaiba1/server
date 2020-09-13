class WorkGroupsController < ApplicationController
  def new
    @work_group = WorkGroup.new
    @worksheet_urls = WorksheetTemplate.all.pluck(:image_url).uniq.select do |url|
      url.include?('res.cloudinary.com/naokimi')
    end
  end

  def create
    if @work_group.save
      # flash notice
      # send email
    else
      render :new
    end
  end
end
