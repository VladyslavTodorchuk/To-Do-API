module Docs
  module V1
    module Sessions
      extend Dox::DSL::Syntax

      document :api do
        resource 'Sessions' do
          group 'Users'
        end

        group 'Users' do
          desc 'Users group'
        end
      end

      document :create do
        action 'Get sessions tokens'
      end

      document :destroy do
        action 'Delete sessions tokens'
      end
    end
  end
end
