class Manager
  @@id_counter = 0

  attr_reader :id, :score, :customers_attended

  def initialize(score)
    @id = generate_id
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

  def generate_id
    @@id_counter += 1
    @@id_counter
  end
end