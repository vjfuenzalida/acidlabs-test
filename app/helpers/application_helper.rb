# frozen_string_literal: true

module ApplicationHelper
  def page_title(separator = ' – ')
    [content_for(:title), 'Weather App'].compact.join(separator)
  end
end
