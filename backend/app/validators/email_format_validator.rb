# frozen_string_literal: true

class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if ModelConstants::EMAIL_REGEXP.match?(value)

    record.errors.add(attribute, :invalid_format)
  end
end
