# frozen_string_literal: true

class StaticPagesController < ApplicationController
  include CinenewsScrape

  def show
    all_info = StaticPagesController.get_schedule(region: :brussel)
    @sorted_screenings = all_info[:sorted_screenings]
    @sorted_screenings.each do |screening|
      screening[:movie_info] = all_info[:movies].find { |movie| movie[:id] == screening[:movie_id] }
    end
    @grouped_screenings = @sorted_screenings.group_by { |screening| screening[:time] }
  end
end
