module Zuul
  module Pundit
    module Argument
      def self.included(base)
        base.send :include, Zuul::Pundit::Policies
      end

      def initialize(*args, **kwargs, &block)
        @pundit_policy_class = kwargs.delete(:pundit_policy_class) if kwargs.key?(:pundit_policy_class)
        @pundit_role = kwargs.delete(:pundit_role) if kwargs.key?(:pundit_role)
        @pundit_visibility = kwargs.delete(:pundit_visibility) if kwargs.key?(:pundit_visibility)
        super(*args, **kwargs, &block)
      end

      def visible?(context)
        super && pundit_visible?(context)
      end

      def authorized?(object, argval, context)
        super && pundit_authorized?(object, context)
      end

      def pundit_subject
        owner.owner_type.pundit_subject
      end
    end
  end
end
