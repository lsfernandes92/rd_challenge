# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'
require_relative 'helpers/scores_build_helper'
require_relative 'helpers/set_customers_helper'
require_relative 'helpers/set_managers_helper'
require_relative '../src/concerns/sortable'

# Swap out the Minitest runner output to the custom one used by the gem minitest-reporters
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
