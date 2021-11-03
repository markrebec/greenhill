module Zuul
  module Pundit
    module Argument
      def initialize(*args, policy_visible: :index?, policy_authorized: :show?, **kwargs, &block)
        @policy_visible = policy_visible
        @policy_authorized = policy_authorized
        super(*args, **kwargs, &block)
      end

      def policy_class
        @_policy_class ||= "#{self.name.demodulize.gsub(/Argument$/, '')}Policy".constantize
      rescue
        nil
      end
      
      def policy(context, object=nil)
        policy_class && policy_class.new(context[:current_user], object)
      end
      
      def visible?(context)
        return super unless policy_class
        super && policy(context).send(@policy_visible)
      end
      
      def authorized?(object, arguments, context)
        return super unless policy_class
        super && policy(context, object).send(@policy_authorized)
      end
    end
  end
end