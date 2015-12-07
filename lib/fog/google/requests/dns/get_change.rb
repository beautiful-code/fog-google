module Fog
  module DNS
    class Google
      ##
      # Fetches the representation of an existing Change.
      #
      # @see https://developers.google.com/cloud-dns/api/v1/changes/get
      class Real
        def get_change(zone_name_or_id, identity)
          api_method = @dns.changes.get
          parameters = {
            "project" => @project,
            "managedZone" => zone_name_or_id,
            "changeId" => identity
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_change(zone_name_or_id, identity)
          if data[:managed_zones].key?(zone_name_or_id)
            zone = data[:managed_zones][zone_name_or_id]
          else
            zone = data[:managed_zones].values.detect { |zone| zone["name"] = zone_name_or_id }
          end

          unless zone
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
          end

          unless data = self.data[:changes][zone["id"]].detect { |c| c["id"] == identity }
            raise Fog::Errors::NotFound, "The 'parameters.changeId' resource named '#{identity}' does not exist."
          end

          build_excon_response(data)
        end
      end
    end
  end
end
