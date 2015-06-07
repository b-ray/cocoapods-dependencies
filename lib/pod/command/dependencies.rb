module Pod
  class Command
    class Dependencies < Command
      self.summary = "Show project's dependency graph."

      self.description = <<-DESC
      Shows the project's dependency graph.
      DESC

      def self.arguments
        [
          CLAide::Argument.new('SOURCE', false),
          CLAide::Argument.new('SPECNAME', false)
        ].concat(super)
      end

      def initialize(argv)
        @source_name_or_url = argv.shift_argument
        @podspec_name = argv.shift_argument
        super
      end

      def validate!
        super
        if @source_name_or_url
          @source = SourcesManager.source_with_name_or_url(@source_name_or_url)
        end
        if @podspec_name
          @podspec = SourcesManager
          .search(Dependency.new(@podspec_name))
          .specification
          .subspec_by_name(@podspec_name)
        end
      end

      def run
        UI.title 'Dependencies' do
          require 'yaml'
          UI.puts "Upwards (pods with dependency to #{@podspec_name}):"
          upwards = search(@podspec_name, true)
          UI.puts upwards.to_yaml
          UI.puts "Downwards (dependencies of #{@podspec_name}):"
          downwards = search(@podspec_name, false)
          UI.puts downwards.to_yaml
        end
      end

      def latest_specifications
        latest_specifications ||= begin
          @source.pods.map { |pod| @source.specification(pod, @source.versions(pod).first) }
        end
      end

      def search(spec_name, upwards)
        search_downwards ||= begin
          latest_specifications.select { |specification| 
            upwards ? Specification.root_name(specification.name.to_s) != spec_name : Specification.root_name(specification.name.to_s) == spec_name
          }.map { |specification|
            recusive_dependencies = specification.all_dependencies + specification.recursive_subspecs.flatten.map { |subspecSpecification| subspecSpecification.all_dependencies }.flatten
            recusive_dependencies.select { |dependency|
              upwards ? dependency.name.to_s.split('/').first == spec_name : dependency.name.to_s.split('/').first != spec_name
            }.map { |dependency| "#{specification.name.to_s.split('/').first} -> #{dependency.name.to_s.split('/').first}"}.uniq.sort
          }.select { |array| !array.empty? }
        end
      end

    end
  end
end
