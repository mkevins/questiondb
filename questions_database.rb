require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

DB = QuestionsDatabase.instance












# class Professor
#   attr_accessor :id, :first_name, :last_name, :department_id
#
#   def initialize(options = {})
#     @id, @first_name, @last_name, @department_id =
#       options.values_at('id', 'first_name', 'last_name', 'department_id')
#   end
#
#   def create
#     raise 'already saved!' unless self.id.nil?
#
#     # execute an INSERT; the '?' gets replaced with the value name. The
#     # '?' lets us separate SQL commands from data, improving
#     # readability, and also safety (lookup SQL injection attack on
#     # wikipedia).
#     params = [self.first_name, self.last_name, self.department_id]
#     SchoolDatabase.instance.execute(<<-SQL, *params)
#       INSERT INTO
#         professors (first_name, last_name, department_id)
#       VALUES
#         (?, ?, ?)
#     SQL
#
#     @id = SchoolDatabase.instance.last_insert_row_id
#   end
# end