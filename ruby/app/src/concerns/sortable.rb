# frozen_string_literal: true

module Sortable
  def sort_by_score(collection) = flatten_collection_values(collection).sort_by(&:last).to_h
  def sort_by_score_descending(collection) = flatten_collection_values(collection).sort_by(&:last).reverse.to_h
  def sort_managers_by_attended_customers_descending(collection) = collection.sort_by(&:customers_attended_id).reverse!

  private

  def flatten_collection_values(colletion) = colletion.map(&:values)
end
