require 'zuul/pundit/object'
require 'zuul/pundit/field'
require 'zuul/pundit/argument'

module Zuul
  module Pundit
    class Context < GraphQL::Query::Context
      def pundit_user
        self[:current_user]
      end
    end

    module Policies
      def pundit_policy_class(klass)
        @pundit_policy_class = klass.is_a?(String) ? klass.safe_constantize : klass
      end

      def pundit_policy_class_for(object, context)
        policy_args = [context.pundit_user, object]
        @pundit_policy_class ? @pundit_policy_class.new(*policy_args) : ::Pundit.policy!(*policy_args)
      end

      def pundit_role(role)
        @pundit_role = role
      end

      def pundit_role_for(object, context)
        raise ::Pundit::NotDefinedError,
          "Please define a default role with `pundit_role :your_role` for #{self.to_s}, or explicitly set `pundit_role nil` to bypass authorization." unless instance_variable_defined?(:@pundit_role)
        "#{@pundit_role.to_s.gsub(/\?*$/, '')}?".to_sym if @pundit_role
      end

      def pundit_visibility!
        @pundit_visibility = true
      end

      def pundit_visibility(role)
        @pundit_visibility = role
      end

      def pundit_visibility_for(object, context)
        if @pundit_visibility === true
          pundit_role_for(object, context)
        elsif @pundit_visibility
          "#{@pundit_visibility.to_s.gsub(/\?*$/, '')}?".to_sym
        end
      end

      def pundit_visible?(context)
        role = pundit_visibility_for(pundit_subject, context)
        return true if role.nil?
        policy = pundit_policy_class_for(pundit_subject, context)
        policy.send(role)
      end
  
      def pundit_authorized?(object, context)
        role = pundit_role_for(object, context)
        return true if role.nil?
        policy = pundit_policy_class_for(object, context)
        policy.send(role)
      end
    end

    module Scopes
      def scope_by_pundit_policy(context, items)
        return items if items.is_a?(Array)
        ::Pundit.policy_scope!(context.pundit_user, items)
      end

      def scope_items(items, context)
        scope_by_pundit_policy(context, items)
      end
    end
  end
end