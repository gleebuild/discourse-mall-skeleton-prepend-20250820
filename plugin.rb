# frozen_string_literal: true
# name: discourse-mall-skeleton-prepend-20250820
# about: Minimal Mall endpoints (hello-style) with highest-priority routes
# version: 0.0.2
# required_version: 3.0.0
# authors: ChatGPT

after_initialize do
  require_dependency 'application_controller'

  module ::Mallx; end

  class ::Mallx::BaseController < ::ApplicationController
    layout 'no_ember_mallx'
    skip_before_action :ensure_logged_in, raise: false
    skip_before_action :redirect_to_login_if_required, raise: false
  end

  class ::Mallx::StoreController < ::Mallx::BaseController
    def index
      render :index
    end

    def admin
      raise Discourse::InvalidAccess.new unless current_user&.admin?
      render :admin
    end
  end

  # Make sure our routes win over Ember's catch-all
  Discourse::Application.routes.prepend do
    get '/mall' => 'mallx/store#index'
    get '/mall/admin' => 'mallx/store#admin'
  end
end
