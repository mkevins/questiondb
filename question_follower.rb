class QuestionFollower

  def self.all
    results = DB.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    DB.execute(<<-SQL, user_id, question_id)
      INSERT INTO
        question_followers (user_id, question_id)
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
        question_followers
      WHERE
        users.id = ?
    SQL

    QuestionFollower.new(results.first)
  end

  def self.followers_for_question_id(question_id)
    results = DB.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_followers INNER JOIN users
        ON question_followers.user_id = users.id
      WHERE
        question_followers.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = DB.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_followers INNER JOIN questions
        ON question_followers.question_id = questions.id
      WHERE
        question_followers.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = DB.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_followers INNER JOIN questions
        ON question_followers.question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_followers.user_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result) }
  end



end