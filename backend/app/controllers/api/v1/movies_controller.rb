# frozen_string_literal: true

module Api
  module V1
    class MoviesController < ApplicationController
      skip_before_action :authenticate_user!, only: :index

      def index
        render json: { meta: pagination, movies: ActiveModelSerializers::SerializableResource.new(resources, each_serializer: MovieSerializer, include: include_option) }
      end

      def create
        @movie = current_user.movies.build(movie_params)
        @movie.save!
        NotifyNewMovieJob.perform_later(current_user, @movie)
        render json: @movie, serializer: MovieSerializer, status: :created
      end

      private

      def resources_scope
        Movie.all.order(id: :desc)
      end

      def include_option
        {
          user: []
        }
      end

      def movie_params
        params.require(:movie).permit(:url)
      end
    end
  end
end
