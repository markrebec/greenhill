module Zuul
  module Pundit
    module Object
      def self.extended(base)
        base.send :extend, Zuul::Pundit::Policies
        base.send :extend, Zuul::Pundit::Scopes
      end

      def visible?(context)
        super && pundit_visible?(context)
      end

      def authorized?(object, context)
        super && pundit_authorized?(object, context)
      end

      def pundit_subject
        graphql_definition.name.safe_constantize
      end

      def field(*args, **kwargs, &block)
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