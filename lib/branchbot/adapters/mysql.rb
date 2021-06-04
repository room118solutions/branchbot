module Branchbot
  module Adapters
    class MySQL < Abstract

      def initialize(*)
        super

        @username = @config['username']
        @password = @config['password']
      end

      private

        attr_reader :username, :password

        def dump_cmd(branch_name)
          %[mysqldump --add-drop-database --user=#{username} --password="#{password}" --databases #{database_name} > "#{dump_file(branch_name)}"]
        end

        def restore_cmd(branch_name)
          %[mysql -u #{username} --password="#{password}" #{database_name} < "#{dump_file(branch_name)}"]
        end

    end
  end
end
