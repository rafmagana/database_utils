module DatabaseUtils
  
  def table_exists?
    ActiveRecord::Base.connection.table_exists?(self.to_s)
  end
  
  def column_exists?(column_name)
    begin
      ActiveRecord::Base.connection.columns(self.to_s).map(&:name).include?(column_name.to_s)
    rescue NoMethodError #actual_columns is empty and it doesn't respond to the map method
      false
    end
  end
  
  def named_index_exists?(index_name)
    ActiveRecord::Base.connection.indexes(self.to_s).map(&:name).include?(index_name.to_s)
  end
  
  ## I encourage you to move the following code outside this file
  ## I put it here just to keep all the code in the same file
  ## The $rails_rake_task global variable is true if we are running a rake task
  begin
    Symbol.class_eval do
      include DatabaseUtils
    end
  
    String.class_eval do
      include DatabaseUtils
    end
  end if $rails_rake_task # include the module only if we are in a rake task
                          #   like rake db:migration

end