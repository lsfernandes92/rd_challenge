module ScoreBuildHelper
  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end

  def sort_by_score(collection)
    flatten_collection(collection).sort_by(&:last).to_h
  end

  private

  def flatten_collection(colletion)
    colletion.map { |hash| hash.values }
  end
end
