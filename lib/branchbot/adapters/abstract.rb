module Branchbot
  module Adapters
    class Abstract

      def self.build(config, dump_folder)
        klass = case config['adapter']
        when 'postgresql'
          PostgreSQL
        when 'mysql2'
          MySQL
        else
          raise UnsupportedDatabase.new(config['adapter'])
        end

        klass.new(config, dump_folder)
      end

      def initialize(config, dump_folder)
        @config = config
        @database_name = config['database']

        @dump_folder = dump_folder
      end

      def dump(branch_name)
        print "Saving state of database on '#{branch_name}' branch..."

        if system(dump_cmd(branch_name))
          print "done!\n"
          true
        else
          print "failed!\n"
          false
        end
      end

      def dump_exists?(branch_name)
        File.exists?(dump_file(branch_name))
      end

      def restore(branch_name)
        print "Restoring #{database_name} to its previous state on this branch..."

        if system(restore_cmd(branch_name))
          print "done!\n"
          true
        else
          print "failed!\n"
          false
        end
      end

      private

        attr_reader :dump_folder, :database_name

        def dump_cmd(branch_name)
          raise NotImplementedError
        end

        def restore_cmd(branch_name)
          raise NotImplementedError
        end

        def dump_file(branch_name)
          # Replace any special characters that may cause file system issues
          branch_name = branch_name.gsub(/[^0-9a-z.\-_]/i, '_')

          "#{dump_folder}/#{database_name}-#{branch_name}"
        end

    end
  end
end
