require 'hydra-file_characterization'

module Hydra::Works
  class CharacterizationService
    # @param [Hydra::PCDM::File] object which has properties to recieve characterization values.
    # @param [String, File] source for characterization to be run on.  File object or path on disk.
    #   If none is provided, it will assume the binary content already present on the object.
    # @param [Hash] options to be passed to characterization.  parser_mapping:, parser_class:, tools:
    def self.run(object, source = nil, options = {})
      new(object, source, options).characterize
    end

    attr_accessor :object, :source, :mapping, :parser_class, :tools

    def initialize(object, source, options)
      @object       = object
      @source       = source
      @mapping      = options.fetch(:parser_mapping, Hydra::Works::Characterization.mapper)
      @parser_class = options.fetch(:parser_class, Hydra::Works::Characterization::FitsDatastream)
      @tools        = options.fetch(:ch12n_tool, :fits)
    end

    # Get given source into form that can be passed to Hydra::FileCharacterization
    # Use Hydra::FileCharacterization to extract metadata (an OM Datastream)
    # Get the terms (and their values) from the extracted metadata
    # Assign the values of the terms to the properties of the object
    def characterize
      content = source_to_content
      extracted_md = extract_metadata(content)
      terms = parse_metadata(extracted_md)
      store_metadata(terms)
    end

    protected

      # @return content of object if source is nil; otherwise, return a File or the source
      def source_to_content
        return object.content if source.nil?
        return File.open(source).read if source.is_a? String
        source.rewind
        source.read
      end

      def extract_metadata(content)
        Hydra::FileCharacterization.characterize(content, file_name, tools) do |cfg|
          cfg[:fits] = Hydra::Derivatives.fits_path
        end
      end

      # Determine the filename to send to Hydra::FileCharacterization. If no source is present,
      # use the name of the file from the object; otherwise, use the supplied source.
      def file_name
        if source
          source.is_a?(File) ? File.basename(source.path) : File.basename(source)
        else
          object.original_name.nil? ? "original_file" : object.original_name
        end
      end

      # Use OM to parse metadata
      def parse_metadata(metadata)
        datastream = parser_class.new
        datastream.ng_xml = metadata if metadata.present?
        characterization_terms(datastream)
      end

      # Get proxy terms and values from the parser
      def characterization_terms(datastream)
        h = {}
        datastream.class.terminology.terms.each_pair do |key, target|
          # a key is a proxy if its target responds to proxied_term
          next unless target.respond_to? :proxied_term
          begin
            h[key] = datastream.send(key)
          rescue NoMethodError
            next
          end
        end
        h.delete_if { |_k, v| v.empty? }
      end

      # Assign values of the instance properties from the metadata mapping :prop => val
      def store_metadata(terms)
        terms.each_pair do |term, value|
          property = property_for(term)
          next if property.nil?
          # Array-ify the value to avoid a conditional here
          Array(value).each { |v| append_property_value(property, v) }
        end
      end

      # Check parser_config then self for matching term.
      # Return property symbol or nil
      def property_for(term)
        if mapping.key?(term) && object.respond_to?(mapping[term])
          mapping[term]
        elsif object.respond_to?(term)
          term
        end
      end

      def append_property_value(property, value)
        value = object.send(property) + [value] unless property == :mime_type
        object.send("#{property}=", value)
      end
  end
end
