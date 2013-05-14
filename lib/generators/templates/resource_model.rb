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

	def won(probability)
    expectation      = (probability == 0) ? 0 : probability > 0
    real_expectation = resource_probability(expectation)
  end

  def resource_probability(expectation)
    result = (expectation == true) ? 'wins' : nil
    result ||= (expectation == false) ? 'losses' : 'draws'

    w = self.wins*100.0/matches
    l = self.losses*100.0/matches
    d = self.draws*100.0/matches

    expectations = {
                      'wins'   =>  { we:0, le:0, de:0 },
                      'losses' =>  { we:0, le:0, de:0 },
                      'draws'  =>  { we:0, le:0, de:0 }
                   }

    expectations.each do |k, v|
      v[:we] = w*(self.expectations['win_expectation'][k]*100.0/self[k])
      v[:le] = l*(self.expectations['lost_expectation'][k]*100.0/self[k])
      v[:de] = d*(self.expectations['draw_expectation'][k]*100.0/self[k])
    end

    (expectations[result][:we] / (expectations[result][:we] + expectations[result][:le] + expectations[result][:de]))*100
  end