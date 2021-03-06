class AdminAssistant
  class DefaultSearchColumn < Column
    def initialize(model_class, opts)
      @model_class = model_class
      @fields_to_match = opts[:fields_to_match] || []
    end
    
    def add_to_query_condition(ar_query_condition, search)
      unless search.params.blank?
        ar_query_condition.ar_query.boolean_join = :and
        ar_query_condition.boolean_join = :or
        @fields_to_match.each do |field_name|
          ar_query_condition.sqls << "LOWER(#{field_name}) like LOWER(?)"
          ar_query_condition.bind_vars << "%#{search.params}%"
        end
      end
    end
    
    def attributes_for_search_object(search_params, compare_to_range)
      {}
    end
      
    def search_view(action_view, admin_assistant, opts={})
      View.new self, action_view
    end
    
    class View
      def initialize(column, action_view)
        @column, @action_view = column, action_view
      end
      
      def html(form)
        @action_view.text_field_tag("search", form.object.params)
      end
    end
  end
end
