require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
  attr_writer

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    Student.insert(self.name, self.grade)
    sql = <<-SQL
      SELECT * FROM students ORDER BY id DESC LIMIT 1
    SQL
    new_hash = DB[:conn].execute(sql)
    # binding.pry
    @id = new_hash[0][0]
    self
  end

  def self.insert(name, grade)

    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)

  end

  def self.create(hash)
    #binding.pry
    new_hash = Student.new(hash[:name],hash[:grade])
    new_hash.save
    new_hash

  end

end
