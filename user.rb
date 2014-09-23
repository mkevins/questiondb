require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'

class User
  def self.all
    results = DB.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    DB.execute(<<-SQL, fname, lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL

    @id = DB.last_insert_row_id
  end

  def self.find_by_id(id)
    results = DB.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(results.first)
  end

  def self.find_by_name(fname, lname)
    results = DB.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    User.new(results.first)
  end

  def self.followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
     Reply.find_by_user_id(id)
  end



end