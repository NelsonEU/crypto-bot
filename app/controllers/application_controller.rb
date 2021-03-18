class ApplicationController < ActionController::API
  def front
    session[:plan] = params[:plan] if params[:plan]

    render html: front_html.html_safe
  end

  private

  def front_html
    Rails.env.production? ? Front::HTML_CACHE : Front.html
  end

  def normalized_params
    DefaultDeserializer.call(params.to_unsafe_hash[:data])
  end

  def render_errors(errors, status = :unprocessable_entity)
    render json: Api::Private::ErrorSerializer.new(errors), status: status
  end

  def render_nothing(status = :ok)
    render json: { meta: {} }, status: status # see: https://jsonapi.org/format/#crud-deleting-responses-200
  end

  # Defines a deserializer with the default options
  class DefaultDeserializer < JSONAPI::Deserializable::Resource
    key_format { |key| key.downcase.underscore }

    id

    has_one
    has_many
    attributes
  end
end
