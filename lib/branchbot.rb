# frozen_string_literal: true

require_relative "branchbot/version"
require_relative "branchbot/adapters/abstract"
require_relative "branchbot/adapters/unsupported_database"
require_relative "branchbot/adapters/mysql"
require_relative "branchbot/adapters/postgresql"
require_relative "branchbot/branch_switcher"

require 'yaml'
require 'erb'
require 'fileutils'

module Branchbot

end
