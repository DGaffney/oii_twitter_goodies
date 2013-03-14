module Twitter
  module API
    module Utils
      def objects_from_response(klass, request_method, path, options={})
        response = send(request_method.to_sym, path, options)
        if response.class == Hash && response[:body]
          response = response[:body]
          objects_from_array(klass, response)
        else
          return response
        end
      end

      def object_from_response(klass, request_method, path, options={})
        response = send(request_method.to_sym, path, options)
        return klass.from_response(response) || response
      end
      
      def cursor_from_response(collection_name, klass, request_method, path, options, method_name)
        merge_default_cursor!(options)
        response = send(request_method.to_sym, path, options)
        if (response.class == Hash || response.class == BSON::OrderedHash) && !response.keys.include?(:body)
          Twitter::Cursor.from_response({:body => response}, collection_name.to_sym, klass, self, method_name, options)
        else
          Twitter::Cursor.from_response(response, collection_name.to_sym, klass, self, method_name, options)
        end
      end
    end
  end
end
