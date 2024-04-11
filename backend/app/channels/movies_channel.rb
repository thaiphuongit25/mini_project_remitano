class MoviesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "movie_user_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
