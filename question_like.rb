class QuestionLike

  def self.all
    results = DB.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result) }
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    DB.execute(<<-SQL, question_id, user_id)
      INSERT INTO
        question_likes (question_id, user_id)
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
        question_likes
      WHERE
        question_likes.id = ?
    SQL

    QuestionLike.new(results.first)
  end

  def self.likers_for_question_id(question_id)
    results = DB.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes INNER JOIN users
        ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    result = DB.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.id) AS count
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL

    result.first['count']
  end

  def self.liked_questions_for_user_id(user_id)
    results = DB.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes INNER JOIN questions
        ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

end