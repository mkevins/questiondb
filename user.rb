class User

  include Saveable

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

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    num_likes = DB.execute(<<-SQL, id)
      SELECT
        COUNT(question_likes.id) AS num_likes
      FROM
        question_likes INNER JOIN questions
        ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
    SQL


    num_questions = DB.execute(<<-SQL, id)
      SELECT
        COUNT(questions.id) AS num_questions
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL

    num_likes.first['num_likes'] / num_questions.first['num_questions'].to_f
  end

end