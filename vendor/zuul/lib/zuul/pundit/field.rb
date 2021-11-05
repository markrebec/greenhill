module Zuul
  module Pundit
    module Field
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

      def authorized?(object, args, context)
        super && pundit_authorized?(object, context)
      end

      def pundit_subject
        owner_type.pundit_subject
      end

      def argument(*args, **kwargs, &block)
        pargs = {}
        pargs[:pundit_policy_class] = @pundit_policy_class if instance_variable_defined?(:@pundit_policy_class)
        pargs[:pundit_role] = @pundit_role if instance_variable_defined?(:@pundit_role)
        pargs[:pundit_visibility] = @pundit_visibility if instance_variable_defined?(:@pundit_visibility)
        kwargs = pargs.merge(kwargs)
        super(*args, **kwargs, &block)
      end
    end
  end
end
