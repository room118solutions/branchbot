module Branchbot
  module Adapters
    class PostgreSQL < Abstract

      private

        def dump_cmd(branch_name)
          # Delete legacy SQL dump, or previous directory-format archive since folder cannot already exist
          if File.exist?(dump_file(branch_name))
            FileUtils.rm_r dump_file(branch_name)
          end

          %[pg_dump --file="#{dump_file(branch_name)}" --format=directory --jobs=#{number_of_jobs} #{database_name}]
        end

        def restore_cmd(branch_name)
          # Drop existing connections
          system(%[psql --command="SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '#{database_name}' AND pid <> pg_backend_pid();" postgres > /dev/null])

          # Drop database
          system(%[dropdb #{database_name}])

          # Create database
          system(%[createdb #{database_name}])

          if File.directory?(dump_file(branch_name))
            # Restore directory-format archive
            %[pg_restore --dbname=#{database_name} --jobs=#{number_of_jobs} "#{dump_file(branch_name)}"]
          else
            # Restore legacy SQL dump
            %[psql --file="#{dump_file(branch_name)}" #{database_name} > /dev/null]
          end
        end

        def number_of_jobs
          require 'etc'

          if Etc.respond_to?(:nprocessors) # Available in 2.2.3+
            Etc.nprocessors
          else
            1
          end
        end

    end
  end
end
