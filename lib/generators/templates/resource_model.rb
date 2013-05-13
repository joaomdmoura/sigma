	serialize :expectations

  scope :ranking, select("#{self.name.pluralize}.*")
    .select("(#{self.name.pluralize}.skill - 3 * #{self.name.pluralize}.doubt) as rating")
    .order("rating DESC")

  def rating
    self.skill - 3 * self.doubt
  end

  def position
    self.class.ranking.index(self)+1
  end

  def matches
    self.wins+self.losses+self.draws
  end

	def won(resource)
    x = rating - resource.rating
    y = x > 0
    z = resource_probability(y)
  end

  def resource_probability(y)
    #TODO
  end