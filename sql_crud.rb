class SQL
  def initialize(table)
    @table = table
  end

  def create(v)
    "INSERT INTO #{@table} VALUES(#{v.join', '});"
  end

  def read(conditions, value = "*")
		value = value.join(', ') if value != "*"
    "SELECT #{value} FROM #{@table} #{where(conditions)};"
  end

  def update(conditions, value)
    "UPDATE #{@table} SET #{set_values(value)} #{where(conditions)};"
  end

  def delete(conditions)
    "DELETE from #{@table} #{where(conditions)};"
  end

  def set_values(h)
    eq(h)
  end

  def eq(h)
    str = ""
    h.each  {|key, value|  str = "#{str}#{key} = '#{value}', "}
    return str[0..-3]
  end

  def into_and(h)
    str = ""
    h.each  {|key, value|  str = "#{str}#{key} = '#{value}' AND "}
    return str[0..-6]# 最後のANDを消す
  end


  def where(h)
    return nil if h == ""
    "where #{into_and(h)}"
  end


end


# 例
tab = SQL.new("tab")

p tab.create([5, "'hoge'", 90])
  # "INSERT INTO tab VALUES(5, 'hoge', 90);"

p tab.read({id: 5, name: "hoge"})
  # "SELECT * FROM tab where id = '5' AND name = 'hoge';"

p tab.read("", ["id", "name", "score"]) 
  # "SELECT id, name, score FROM tab ;"

p tab.update({name: "huga"}, {id: 5, name: "hoge"})
  # "UPDATE tab SET id = '5', name = 'hoge' where name = 'huga';"

p tab.delete({id: 5, name: "hoge"})
  # "DELETE from tab where id = '5' AND name = 'hoge';"
