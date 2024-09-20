module Sortable
  def sort_by_score(collection)
    flatten_collection_values(collection).sort_by(&:last).to_h
  end

  def sort_by_score_descending(collection)
    flatten_collection_values(collection).sort_by(&:last).reverse.to_h
  end

  private

  def flatten_collection_values(colletion)
    colletion.map(&:values)
  end
end