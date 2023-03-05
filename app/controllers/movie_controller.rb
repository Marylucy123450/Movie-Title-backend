class MovieController < AppController

    set :views, './app/views'

    # @method: Display a small welcome message
    get '/hello' do
        "Our very first controller"
    end

    # @method: Add a new TO-DO to the DB
    post '/movies/create' do
        begin
            movie = Movie.create( self.data(create: true) )
            json_response(code: 201, data: movie)
        rescue => e
            json_response(code: 422, data: { error: e.message })
        end
    end

    # @method: Display all todos
    get '/movies' do
        movies = Movie.all
        json_response(data: movies)
    end

    # @view: Renders an erb file which shows all TODOs
    # erb has content_type because we want to override the default set above
    get '/' do
        @movies = Movie.all.map { |movie|
          {
            movie: movie,
            badge: movie_status_badge(movie.status)
          }
        }
        @i = 1
        erb_response :movies
    end

    # @method: Update existing TO-DO according to :id
    put '/movies/update/:id' do
        begin
            movie = Movie.find(self.movie_id)
            movie.update(self.data)
            json_response(data: { message: "movie updated successfully" })
        rescue => e
            json_response(code: 422 ,data: { error: e.message })
        end
    end

    # @method: Delete TO-DO based on :id
    delete '/movies/destroy/:id' do
        begin
            movie = Movie.find(self.movie_id)
            movie.destroy
            json_response(data: { message: "movie deleted successfully" })
        rescue => e
          json_response(code: 422, data: { error: e.message })
        end
    end


    private

    # @helper: format body data
    def data(create: false)
        payload = JSON.parse(request.body.read)
        if create
            payload["createdAt"] = Time.now
        end
        payload
    end

    # @helper: retrieve to-do :id
    def movie_id
        params['id'].to_i
    end

    # @helper: format status style
    def movie_status_badge(status)
        case status
            when 'CREATED'
                'bg-info'
            when 'ONGOING'
                'bg-success'
            when 'CANCELLED'
                'bg-primary'
            when 'COMPLETED'
                'bg-warning'
            else
                'bg-dark'
        end
    end


end