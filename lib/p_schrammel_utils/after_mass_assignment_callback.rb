# -*- encoding : utf-8 -*-
#use this if you want to fix your model after some mas assignment:
#like new(:ok => 'ok') or update_attributes or attributes =
#include it in your ActiveRecord derived class.
module PSchrammelUtils
  module AfterMassAssignmentCallback
    def self.included(base)
      base.__send__(:include, InstanceMethods)
      base.define_model_callbacks :mass_assignment,:only => [:after]
    end

    module InstanceMethods
      def mass_assigning?
        @mass_assigning
      end

      def attributes=(_attributes, guard_protected_attributes = true)
        _run_mass_assignment_callbacks do
          begin
            @mass_assigning = true
            super(_attributes, guard_protected_attributes)
          ensure
            @mass_assigning = false
          end
        end
      end
    end

  end
end
