module Zuul
  module Pundit
    module Object
      def policy_class(pclass=nil)
        @policy_class = pclass unless pclass.nil?
        @policy_class ||= Zuul::Pundit.policy_class(self)
      end

      def scope_class(sclass=nil)
        @scope_class = sclass unless sclass.nil?
        @scope_class ||= Zuul::Pundit.scope_class(self)
      end

      def visible_policy(vpol=nil)
        @visible_policy = vpol unless vpol.nil?
        @visible_policy ||= :index?
      end

      def authorized_policy(apol=nil)
        @authorized_policy = apol unless apol.nil?
        @authorized_policy ||= :show?
      end

      def policy_object(context, object=nil)
        return unless policy_class
        policy_class.new(context[:current_user], object)
      end

      def scope_object(context, items)
        return unless scope_class
        scope_class.new(context[:current_user], items)
      end

      def visible?(context)
        result = super
        return result unless result

        policy = policy_object(context)
        return result unless policy

        return policy.send(visible_policy)
      end

      def authorized?(object, context)
        result = super
        return result unless result

        policy = policy_object(context, object)
        return result unless policy

        return policy.send(authorized_policy)
      end

      def scope_items(items, context)
        scope = scope_object(context, items)
        return items unless scope
        scope.resolve
      end
    end
  end
end