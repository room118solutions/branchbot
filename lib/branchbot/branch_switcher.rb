module Branchbot
  class BranchSwitcher
    def switch_from(prev_ref)
      # Get the current (destination) branch
      @destination_branch = `git rev-parse --abbrev-ref HEAD`.strip

      # Since we're just given a commit ID referencing the branch head we're coming from,
      # it could be at the head of multiple branches. We can assume the source isn't the same as the
      # destination branch, so we can remove that immediately.
      @source_branches = branches_from_refhead(prev_ref).reject{ |b| b == @destination_branch }

      @project_root = %x[git rev-parse --show-toplevel].strip
      @dump_folder = "#{@project_root}/.db_branch_dumps"

      # Load Rails DB config and grab database name
      @rails_db_config = YAML.load(ERB.new(File.read("#{@project_root}/config/database.yml")).result)
      dev_database_name = @rails_db_config['development']['database']

      begin
        @adapter = Adapters::Abstract.build(@rails_db_config['development'], @dump_folder)
      rescue Adapters::UnsupportedDatabase => e
        puts "\nERROR: #{e.message}"
        exit
      end

      # Ensure dump directory exists
      unless Dir.exists?(@dump_folder)
        Dir.mkdir @dump_folder
      end

      # Don't do anything if the source and destination branches are the same or nonexistent
      unless @source_branches.include?(@destination_branch) || @source_branches.empty? || (@source_branches | [@destination_branch]).any?{ |b| b == '' }
        # Dump database for source branches
        if @source_branches.all? { |branch| @adapter.dump(branch) }
          # Restore dump from this branch, if it exists
          if @adapter.dump_exists?(@destination_branch)
            if @adapter.restore(@destination_branch)
              prepare_test_database
            end
          else
            print "No DB dump for #{dev_database_name} on the '#{@destination_branch}' branch was found!\n"
            print "The state of your database has been saved for when you return to the '#{@source_branches.join('\' or \'')}' branch, but its current state has been left unchanged.  You are now free to make changes to it that are specific to this branch, and they will be saved when you checkout a different branch, then restored when you checkout this one again.\n"
          end
        else
          print "Failed to dump database. Halting.\n"
        end
      end
    end

    private

      def branches_from_refhead(ref)
        `git show-ref --heads | grep #{ref} | awk '{print $2}'`.split("\n").map{ |b| b.sub(/^refs\/heads\//, '') }
      end

      def prepare_test_database
        if File.exists?("#{@project_root}/Rakefile")
          print "Preparing test database..."

          rake_cmd = "rake db:test:prepare"

          if File.exists?("#{@project_root}/bin/rake")
            rake_cmd = "./bin/#{rake_cmd}"
          elsif File.exists?("#{@project_root}/Gemfile")
            rake_cmd = "bundle exec #{rake_cmd}"
          end

          system rake_cmd

          print "done!\n"
        else
          print "No Rakefile detected, skipping test database restoration\n"
        end
      end
    end
end