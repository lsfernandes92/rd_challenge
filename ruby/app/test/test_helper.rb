require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'helpers/scores_build_helper'

# Swap out the Minitest runner output to the custom one used by the gem minitest-reporters
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]