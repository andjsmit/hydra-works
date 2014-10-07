module Hydra::Works
  module CurationConcern
    module HasRepresentative
      extend ActiveSupport::Concern

      included do
        has_attributes :representative, datastream: :properties, multiple: false
      end

      def to_solr(solr_doc={}, opts={})
        super.tap do |solr_doc|
          solr_doc[Solrizer.solr_name('representative', :stored_searchable)] = representative
        end
      end

    end
  end
end
