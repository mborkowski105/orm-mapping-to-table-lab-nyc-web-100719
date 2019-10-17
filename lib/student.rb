class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade 
  attr_reader :id
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
	#class method creates table, not individual instance
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql) 
  end
  
  def self.drop_table
    sql =  <<-SQL 
      DROP TABLE IF EXISTS students
        SQL
    DB[:conn].execute(sql) 
  end
  
  def self.create(attributes)
    	student = Student.new(nil, nil)
    	attributes.each do |key, value|
    	  student[key] = value  
    	end
    	student.save
    	student
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)
 
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end
