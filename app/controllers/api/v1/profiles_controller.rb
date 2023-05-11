# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      def me
        authorize! :me, current_resource_owner
        render json: current_resource_owner
      end
    end
  end
end
