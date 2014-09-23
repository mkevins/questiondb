module Saveable

  def save
    id ? update : create
  end


  def create
    vars = self.instance_variables
    vars.delete(:@id)
    str_vars = vars.map(&:to_s).map { |str| str[1..-1] }.map!(&:to_sym)
    #vars << :@id
    values = vars.map { |sym| instance_variable_get(sym) }
    table = (self.class == Reply ? 'replies' : self.class.to_s.downcase + 's')

    DB.execute(<<-SQL, *values)
      INSERT INTO
        #{table} (#{str_vars.join(',')})
      VALUES
        (#{vars.map { |var| '?'}.join(', ')})
    SQL

    @id = DB.last_insert_row_id
  end


  def update
    vars = self.instance_variables
    vars.delete(:@id)
    str_vars = vars.map(&:to_s).map { |str| str[1..-1] }.map!(&:to_sym)
    vars << :@id
    values = vars.map { |sym| instance_variable_get(sym) }

    table = (self.class == Reply ? 'replies' : self.class.to_s.downcase + 's')
    sets = str_vars.map { |var| "#{var} = ?" }.join(", ")

    DB.execute(<<-SQL, *values)
      UPDATE
        #{table}
      SET
        #{sets}
      WHERE
      #{table}.id = ?

    SQL

  end

end