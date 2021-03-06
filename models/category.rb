require_relative('../db/sql_runner')
require('pry-byebug')

class Category

    attr_reader :id, :type

  def initialize(options)
    @id = options['id'].to_i
    @type = options['type']
  end 

  def save()
    sql = "INSERT INTO categories (type) VALUES ('#{@type}') RETURNING *"
    category = SqlRunner.run(sql).first
    @id = category['id'].to_i
  end 

  def self.delete_all()
    sql = "DELETE FROM categories"
    SqlRunner.run(sql)
  end 

  #insert a method that returns the total cost of all the prices for items corrosponding with each categorys id
  def specific_total()
    sql = " SELECT SUM(cost) FROM transactions WHERE category_id = #{@id} "
    total = SqlRunner.run(sql).first
    # binding.pry
        return total['sum'].to_f
  end 
#this was needed for the specific totals in each category 


#needed for the destory method in the controller
  def self.destory(id)
   sql = "DELETE FROM categories WHERE id = #{id}"
   SqlRunner.run(sql)
  end 

  def self.all()
    sql = "SELECT * FROM categories"
    return Category.map_items(sql)
  end 

  def self.find(id)
    sql = "SELECT * FROM categories WHERE id = #{id}"
    return Category.map_item(sql)
  end 

  def self.map_items(sql)
    categories = SqlRunner.run(sql)
    result = categories.map{ |category| Category.new(category)}
    return result 
  end 
      #for the update method in the controller 
  def self.update(options)
      sql = "UPDATE categories SET 
      type = '#{options['type']}'
      WHERE id='#{options['id']}'"
    SqlRunner.run(sql)
  end 

  def update
    sql = "UPDATE categories SET 
      type = '#{ @type }',
      WHERE id = #{@id};"
    SqlRunner.run(sql)
    return nil
  end
  # to get back all the different merchants who hold a specifically chosen item 
  # def merchants
  #   sql = "SELECT merchants.* FROM merchants INNER JOIN transactions ON transactions.merchant_id = merchants.id WHERE transactions.category_id = #{@id};" 
  #     return Merchant.map_items(sql)
  # end 

  def transactions
    sql = "SELECT * FROM transactions WHERE category_id = #{@id}"
    result = Transaction.map_items(sql)
    return result    
  end 
 
  def self.map_item(sql)
    result = Category.map_items(sql)
    return result.first
  end
end 