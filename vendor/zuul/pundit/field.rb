module Zuul
  module Pundit
    module Field
      def initialize(*args, policy_class: nil, policy_method: nil, visible_policy: nil, authorized_policy: nil, **kwargs, &block)
        @policy_class = policy_class
        @policy_method = policy_method
        @visible_policy = visible_policy
        @authorized_policy = authorized_policy
        super(*args, **kwargs, &block)
      end

      def policy_class
        @policy_class ||= owner_type.try(:policy_class) || Zuul::Pundit.policy_class(owner_type)
      end

      def policy_object(context, object=nil)
        return unless policy_class
        policy_class.new(context[:current_user], object)
      end

      def policy_method
        @policy_method ||= "#{name}?".to_sym
      end

      def visible?(context)
        result = super
        return result unless result

        policy = policy_object(context)
        return result unless policy

        return policy.send(@visible_policy) if @visible_policy
        return policy.send(policy_method) if policy.respond_to?(policy_method)
        return policy.send(owner_type.visible_policy) if owner_type.respond_to?(:visible_policy)
        return result
      end

      def authorized?(object, arguments, context)
        result = super
        return result unless result

        policy = policy_object(context, object)
        return result unless policy

        return policy.send(@authorized_policy) if @authorized_policy
        return policy.send(policy_method) if policy.respond_to?(policy_method)
        return policy.send(owner_type.authorized_policy) if owner_type.respond_to?(:authorized_policy)
        return result
      end
    end
  end
end
