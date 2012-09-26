
module Api
  module V1
    class UsersController < ActionController::Base
      doorkeeper_for :all
      respond_to :json

      def show
        respond_with current_user.to_json(:except => :password_digest)
      end

      def organization_users
        if current_user.role == 'cso_admin'
          organization = current_user.organization
          users = organization.users - [].push(current_user)
          respond_with users.to_json(:only => [:id, :name])
        else
          respond_with "not authorized"
        end
      end

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
