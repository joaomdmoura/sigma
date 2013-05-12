	scope :ranking, select("#{self.name.pluralize}.*")
    .select("(#{self.name.pluralize}.skill - 3 * #{self.name.pluralize}.doubt) as rating")
    .order("rating DESC")

	def rating
	  @rating ||= self[:rating] || self.skill - 3 * self.doubt
	end