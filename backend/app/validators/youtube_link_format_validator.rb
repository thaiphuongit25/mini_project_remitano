class YoutubeLinkFormatValidator < ActiveModel::EachValidator
  YOUTUBE_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  def validate_each(record, attr_name, value)
    return unless value.present? && value !~ YOUTUBE_LINK_FORMAT

    record.errors.add(attr_name, :invalid)
  end
end
