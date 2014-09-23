class Question

  def self.all
    results = DB.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    DB.execute(<<-SQL, title, body, author_id)
      INSERT INTO
        questions (title, body, author_id) #{}
      VALUES
        (?, ?, ?)
    SQL

    @id = DB.last_insert_row_id
  end

  def self.find_by_id(id)
    results = DB.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Question.new(results.first)
  end

  def self.find_by_author_id(author_id)
    results = DB.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.followers
    QuestionFollowers.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end


end