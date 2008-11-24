require File.join(File.dirname(__FILE__), "/test_helper")

ActiveRecord::Base.class_eval do
  alias_method :save, :valid?

  def self.columns() @columns ||= []; end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end

class Article < ActiveRecord::Base
  column :id, :integer
  column :title, :string
  column :body, :text
end

class Book < ActiveRecord::Base
  column :id, :integer
  column :title, :string
  
  encrypted :with => :title
end

class UrlEncryptTest < Test::Unit::TestCase
  
  def test_should_not_encrypt_when_not_declared
    article = Article.new(:title => "some title")
    article.id = '654765498479'
    assert_equal article.to_param, "654765498479"
  end
  
  def test_should_encrypt_column_when_declared
    book = Book.new
    book.title = "some title"
    
    assert_equal book.to_param, "2ccc216a3fd804c52c152a1659f03ebd"
  end
  
  def test_should_get_record_on_find_by_encrypted_column    
    book = Book.new(:title => "some title")    
    Book.expects(:find_initial).returns(book)

    assert_equal Book.respond_to?(:find_by_encrypted_title), false
    assert_equal Book.find_by_encrypted_title('2ccc216a3fd804c52c152a1659f03ebd'), book
    assert_equal Book.respond_to?(:find_by_encrypted_title), true
  end

  def test_should_get_all_records_on_find_all_by_encrypted_column    
    book = Book.new(:title => "some title")    
    Book.expects(:find_every).returns(book)

    assert_equal Book.respond_to?(:find_all_by_encrypted_title), false
    assert_equal Book.find_all_by_encrypted_title('2ccc216a3fd804c52c152a1659f03ebd'), book
    assert_equal Book.respond_to?(:find_all_by_encrypted_title), true
  end
end
