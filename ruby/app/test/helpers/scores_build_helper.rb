# frozen_string_literal: true

module ScoresBuildHelper
  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: }
    end
  end
end
