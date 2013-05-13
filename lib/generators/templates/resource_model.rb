  def self.ranking
    ActiveRecord::Base.connection.execute("SET @i = 0;")
    ActiveRecord::Base.connection.select_all("SELECT #{self.name.pluralize}.*, (#{self.name.pluralize}.skill - 3 * #{self.name.pluralize}.doubt) as rating, (@i := @i+1) as position FROM #{self.name.pluralize} ORDER BY rating DESC;")
  end

  def rating
    @rating ||= self[:rating] || self.skill - 3 * self.doubt
  end