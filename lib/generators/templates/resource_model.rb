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
    self.wins + self.losses + self.draws
  end

  def won(match_difficult)
    define_match_data(match_difficult)
    self.skill = self.skill + (self.skill * @alpha)
    update_sigma('wins')
    self.increment :wins
    self.save
  end

  def lost(match_difficult)
    define_match_data(match_difficult)
    self.skill = self.skill - (self.skill * @alpha)
    update_sigma('losses')
    self.increment :losses
    self.save
  end

  def define_match_data(match_difficult)
    @resource_probability = probability(expectation)
    @match_difficult      = match_difficult.abs
    @expectation          = (match_difficult == 0) ? 0 : match_difficult > 0
    @alpha                = (match_difficult / 50.0)**2.0 #SCALE
  end

  def update_sigma(expectation)
    if @expectation
      expectations                                       = self.expectations['win_expectation'][expectation]
      salpha                                             = ((@resource_probability - 1).abs) * @alpha
      self.doubt                                         = self.doubt - (self.doubt * salpha)
      self.expectations['win_expectation'][expectation]  = expectations + 1
    else
      expectations                                       = self.expectations['lost_expectation'][expectation]
      salpha                                             = @resource_probability * alpha
      self.doubt                                         = self.doubt + (self.doubt * salpha)
      self.expectations['lost_expectation'][expectation] = expectations + 1
    end
  end

  def probability(expectation)
    result = (expectation == true) ? 'wins' : nil
    result ||= (expectation == false) ? 'losses' : 'draws'

    w = self.wins   * 100.0 / ((matches == 0) ? 1 : matches)
    l = self.losses * 100.0 / ((matches == 0) ? 1 : matches)
    d = self.draws  * 100.0 / ((matches == 0) ? 1 : matches)

    expectations = {
                      'wins'   =>  { we:0, le:0, de:0 },
                      'losses' =>  { we:0, le:0, de:0 },
                      'draws'  =>  { we:0, le:0, de:0 }
                   }

    expectations.each do |k, v|
      v[:we] = w*(self.expectations['win_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:le] = l*(self.expectations['lost_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:de] = d*(self.expectations['draw_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
    end
    
    all_probabilities = expectations[result][:we]+expectations[result][:le]+expectations[result][:de]
    probability       = expectations[result][:we] / ((all_probabilities == 0) ? 1 : all_probabilities)

    (probability == 0.0) ? 0.5 : probability
  end