require "sinatra/base"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/json"


class Band < ActiveRecord::Base
    has_many :artists, through: :leaders
    has_and_belongs_to_many :genres
    has_one :rating
    has_many :albums
    has_many :leaders do 
        def << (artist)
            band = proxy_association.owner
            artist.save! if artist.new_record?
            band.save! if band.new_record?
            leader = Leader.create!(artist_id: artist.id, band_id: band.id, leader: true)
            self.push(leader)
        end
    end

    # TODO: validate name presence

    def bandleaders
        leaders.where(leader: true).map(&:artist)
    end
end

class Rating < ActiveRecord::Base
    belongs_to :band
    belongs_to :album

    validates :value, inclusion: { in: 0..10 }, :allow_blank => true
end

class Artist < ActiveRecord::Base
    has_many :bands, through: :leaders
    has_many :leaders
    has_and_belongs_to_many :albums

    def make_leader_of(band)
        band.save! if band.new_record?
        self.save! if self.new_record?
        band.leaders << Leader.create!(artist_id: self.id, band_id: band.id, leader: true)
    end

    def leader_of?(band)
        self.leaders.where(band_id: band.id, artist_id: self.id, leader: true).any? ? true : false
    end

    def unmake_leader_of(band)
        leader = Leader.where(band_id: band.id, artist_id: self.id, leader: true).first
        leader.update_attributes!(leader: false) if leader
    end
end

class Album < ActiveRecord::Base
    belongs_to :band
    has_one :rating
    has_and_belongs_to_many :artists
end

class Song < ActiveRecord::Base

end    

class Leader < ActiveRecord::Base
    belongs_to :artist
    belongs_to :band
end

class Genre < ActiveRecord::Base
    has_and_belongs_to_many :bands
    validates_uniqueness_of :name
    # has_and_belongs_to_many :artists
    # has_and_belongs_to_many :albums
end

class Response

    def initialize(uri, method)
        @uri = uri
        @method = method
    end

    def return_data(data, status=200, message="")
        {
            uri: @uri,
            method: @method,
            status: status,
            message: message,
            data: data
        }
    end

end

class Muslink < Sinatra::Base

    ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database =>  './db/development.sqlite3'
    )

    configure :development do
        register Sinatra::Reloader
        set :server, 'thin'
        set :database, {adapter: "sqlite3", database: "./db/development.sqlite3"}
        enable :logging
    end
    helpers Sinatra::JSON
    enable :sessions

    register Sinatra::ActiveRecordExtension
    # set :root, File.dirname(__FILE__) + '/front/app'
    set :public_folder, File.dirname(__FILE__) + '/front/app'

    set(:methods) do |*methods|
        methods = methods.map(&:to_s).map(&:upcase)
        condition { methods.include? request.request_method }
    end

    before :methods => [:post, :put] do
        @data = {}
        begin
            request.body.rewind  # in case someone already read it
            body = request.body.read
            @data = JSON.parse body unless body.blank?
        rescue JSON::ParserError
            puts "Something broke: #{$!}"
        end
    end

    before :methods => [:get] do
        begin
            @count = params[:count]
            @offset = params[:offset]
            @order = params[:order].try{|o| o.upcase.eql?('DESC') ? 'DESC' : 'ASC'} || 'ASC'
            @order_by = params[:order_by]
            @query = params[:query]
        rescue Exception => e
            puts "Something broke: #{e.message}"
        end
    end

    getRoot = lambda do 
        body = {
            f: 1,
            r: 2
        }
        status 200
        JSON.pretty_generate body
    end

    postRoot = lambda do
        response = {
            ready: request.user_agent
        }
        json @data['text']
        # json response
    end

    putRoot = lambda do
        response = {
            ready: request.user_agent
        }
        json @data['text']
        # json response
    end

    load_angular = lambda do 
        File.read "#{Dir.pwd}/app/front/app/index.html"
    end

    # GET bands list
    bands = lambda do
        bands_q = @query ? Band.where("name like ?", "%#{@query}%") : Band

        total_count = bands_q.count
        puts @order_by.eql?('rating')
        bands_query = case @order_by
            when *Band.attribute_names
                bands_q.order("#{@order_by} #{@order}")
            when 'rating'
                bands_q.joins(:rating).order("ratings.value #{@order}")
            else
                bands_q.order("name #{@order}")
        end
        bands_query = @offset ? bands_query.offset(@offset) : bands_query
        bands_query = @count ? bands_query.limit(@count) : bands_query

        data = {}

        data[:count] = total_count
        data[:bands] = bands_query.as_json(
            include: {
                rating: {
                    only: :value
                }
            }
        )
        JSON.pretty_generate Response.new(request.path_info, request.request_method).return_data(data)
    end

    # GET band info
    band = lambda do
        band = Band.where(id: params[:id]).includes(:artists, :leaders).first || {}
        if band.present?
            artists = band.leaders.map{|leader| leader.artist.attributes.merge(leader.attributes.select{|l| l.include? 'leader'})}
            genres = band.genres.as_json(only: :name)
            albums = band.albums.as_json(only: :name, include: {
                rating: {
                    only: :value
                }
            })
            rating = band.rating.try{|r| r.as_json(only: :value)}
            band = band.as_json
            band[:artists] = artists
            band[:genres] = genres
            band[:rating] = rating
            band[:albums] = albums
        end

        data = band || {}
        # JSON.pretty_generate band.as_json(include: {
        #     artists: {
        #         include: :leaders
        #     }
        # })
        # JSON.pretty_generate band.as_json
        JSON.pretty_generate Response.new(request.path_info, request.request_method).return_data(data)
    end

    # PUT update band
    updateBand = lambda do
        status = 200
        message = ""
        band = Band.find(params[:id])
        if @data["rating"]
            rating = band.rating || (band.rating = Rating.new)
            rating.value = @data["rating"].to_i
            rating.save!
        end
        band_info = @data["band"]
        if band_info
            if band_info["name"].present? && !band_info["name"].eql?(band.name)
                band_names = Band.pluck(:name)
                # band_names.delete(band_info["name"])
                if band_names.include?(band_info["name"])
                    status = 407
                    message = "Band '#{band_info["name"]}' already exists with id=#{Band.find_by(name: band_info["name"]).id}"
                else
                    band.name = band_info["name"]
                end
            end
            band.name = band_info["name"] unless band_info["name"].blank?
            if band_info["genres"].blank?
                band.genres.delete_all
            else
                band_genres = band.genres.pluck(:name)
                new_genres = band_info["genres"]
                genres_to_remove = band_genres - new_genres
                genres_to_add = new_genres - band_genres
                genres_to_remove.map!{|genre_name| Genre.find_by(name: genre_name)}
                band.genres.delete(genres_to_remove)
                genres_to_add.each do |genre|
                    band.genres << Genre.find_or_create_by(name: genre)
                end
            end
        end
        band.save! if band.changed?
        JSON.pretty_generate Response.new(request.path_info, request.request_method).return_data(band.as_json, status, message)
        # JSON.pretty_generate @data.as_json
    end

    band_dup = lambda do
        band = Band.find_by("lower(name) = ?", params[:new_name].try(&:downcase)) || {}
        JSON.pretty_generate Response.new(request.path_info, request.request_method).return_data(band.as_json)
    end

    genres = lambda do
        genres = []
        if @query
            genres = Band.where("name like ?", "%#{@query}%").map{|b| b.genres}.flatten.group_by{|x| x['name']}.map{|k,v| {name: k, count: v.count}}
        else
            Genre.all.each do |genre|
                genres << {name: genre.name, count: genre.bands.count} if (genre.bands.count.present? || params[:all].present?)
            end  
        end
        data = genres
        JSON.pretty_generate Response.new(request.path_info, request.request_method).return_data(data)
    end
    
    # routes
    # get '/', &getRoot
    post '/', &postRoot
    put '/', &putRoot

    get '/', &load_angular

    # API
    get '/api/v1/bands', :provides => [:json], &bands

    get '/api/v1/bands/dup', :provides => [:json], &band_dup

    get '/api/v1/bands/:id', :provides => [:json], &band

    put '/api/v1/bands/:id', :provides => [:json], &updateBand

    get '/api/v1/genres', :provides => [:json], &genres

    not_found do
        status 404
        # redirect "/index.html"
    end

end