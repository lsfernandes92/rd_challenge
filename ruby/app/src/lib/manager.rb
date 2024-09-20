class Manager
  attr_reader :id, :score, :customers_attended

  def initialize(id, score)
    @id = id
    @score = score
    @customers_attended = []
  end

  def attend_customers(customers)
    customers.each do |customer_id, customer_score|
      if attend_customer?(customer_score)
        @customers_attended << customer_id
      end
    end

    @customers_attended
  end

  private

  def attend_customer?(customer_score)
    @score >= customer_score
  end
end