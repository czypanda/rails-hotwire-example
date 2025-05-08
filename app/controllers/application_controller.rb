class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  helper Components::ButtonHelper

  private

  def current_view
    session[:preferred_view] || 'list'
  end

  def render_turbo_stream_flash_messages
    turbo_stream.update "flash", partial: "components/ui/toast", locals: { flash: flash }
  end
end
