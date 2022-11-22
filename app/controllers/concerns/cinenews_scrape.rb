# frozen_string_literal: true

require 'set'

module CinenewsScrape
  extend ActiveSupport::Concern

  CINEMAS = {
    brussel: { aventure: 'aventure-brussels', flagey: 'flagey', galeries: 'galeries', nova: 'nova-brussels',
               palace: 'cinema-palace', vendome: 'vendome' },
    antwerpen: { ugc_antwerpen: 'ugc-antwerpen' }
  }.freeze
  Cinenews_ref_date = Date.parse('30-12-1899') # voor berekening van cinenews_dag_id

  class_methods do
    def get_schedule(_from_time = DateTime.current, region = :brussel)
      # if from_time = today:
      get_schedule_today(region)
      # else
    end

    # onderscheid: gemakkelijker want voor tonen van 1 cinema voor vandaag
    # staat alle info op 1 pagina. Voor volgende dagen moet het anders.
    def get_schedule_today(region)
      screenings_today_array = []
      city_cinemas(region).each do |cinema|
        url = "https://www.cinenews.be/nl/bioscoop/#{cinema_sym_to_string(cinema)}/"
        cinema_scrape = scrape_movies_1_cinema_today(url, cinema)
        cinema_scrape.each do |movie|
          next if movie.nil?

          if screenings_today_array[movie[:movie_info][:id]].nil?
            screenings_today_array[movie[:movie_info][:id]] = movie
          else
            screenings_today_array[movie[:movie_info][:id]][:screening_info] << movie[:screening_info]
          end
        end
      end
      movies_array = screenings_today_array.compact
      {
        movies: movies_array.pluck(:movie_info),
        # sorted screenings by time
        sorted_screenings: movies_array.pluck(:screening_info).flatten.sort_by! { |screening| screening[:time] }
      }
    end

    # def get_schedule_other_day
    #   cinenews_date_id = date_to_cinenews_day_id(from_time)
    #   url = "#{Cinenews_domain}cinema/filmagenda/vaandag/#{region}/?PlayingDate=#{cinenews_date_id}-0"
    #   movies = scrape_movies(url, region)
    # end

    def scrape_movies_1_cinema_today(url, cinema)
      html_file = URI.parse(url).open.read
      html_doc = Nokogiri::HTML(html_file)
      movies_noko = html_doc.css('.movies-list article.movies-stk[data-movies-id]')
      cinema_scrape = []
      movies_noko.each do |movie_noko|
        movie_info = extract_movie_info_from_scrape(movie_noko)
        cinema_scrape[movie_info[:id]] = {
          movie_info: movie_info,
          screening_info: extract_screenings_from_scrape(movie_id_arg: movie_info[:id],
                                                         noko: movie_noko, cinema_arg: cinema)
        }
      end
      cinema_scrape
    end

    def scrape_movies_other_day(url, region)
      # html_file = URI.open(url).read
      # html_doc = Nokogiri::HTML(html_file)
      # movies_noko = html_doc.css(".movies-list article")
      # scraped_movies = {}
      # movies_noko.each do |movie|
      # end
    end

    # returns cities for a city (in symbol form)
    def city_cinemas(city)
      CINEMAS[city].keys
    end

    def cinema_string_to_sym(cinema_string)
      get_cinemas_hash_of_hashes.key(cinema_string)
    end

    def cinema_sym_to_string(cinema_sym)
      get_cinemas_hash_of_hashes[cinema_sym]
    end

    def date_to_cinenews_day_id(from_time)
      (from_time.to_date - Cinenews_ref_date).to_i # otherwise gives rational
    end

    private

    def extract_movie_info_from_scrape(noko)
      res_movie = {}
      res_movie[:title] = noko.css('.stk-title a').text
      res_movie[:url] = noko.css('.stk-title').at(:a)[:href]
      res_movie[:id] = noko.attribute('data-movies-id').value.to_i
      res_movie[:image] = noko.css('.stk-image img').attribute('data-src').value
      res_movie[:trailer] = noko.css('.stk-actions a').attribute('href').value
      res_movie[:genres] = noko.css(".stk-type a[itemprop='genre']").map(&:content)
      res_movie[:synosis_short] = noko.css('.stk-description').text
      res_movie
    end

    def extract_screenings_from_scrape(movie_id_arg:, noko:, cinema_arg:)
      noko.css('.showtimes-list li').map do |li|
        { movie_id: movie_id_arg,
          cinema: cinema_arg,
          time: Time.zone.parse(li.css('.t').text),
          versie: li.css('.v').text.split[0],
          subs: li.css('.v').text.split[1]&.split('/')&.map { |lang| lang.downcase.to_sym } }
      end
    end

    # remove city information, returns a hash of hashes with key and corresponding string
    def get_cinemas_hash_of_hashes
      array_of_arrays = CINEMAS.values.flat_map(&:to_a)
      hash_of_hashes = {}
      array_of_arrays.each { |couple| hash_of_hashes[couple[0]] = couple[1] }
      hash_of_hashes
    end
  end
end
