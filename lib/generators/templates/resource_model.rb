  serialize :expectations

  scope :ranking, select("#{self.name.pluralize}.*")
    .select("(#{self.name.pluralize}.skill - 3 * #{self.name.pluralize}.doubt) as rating")
    .order("rating DESC")

  def rating
    self.skill - 3 * self.doubt
  end

  def position
    self.class.ranking.index(self) + 1
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

  def define_match_data(difficult)
    @expectation          = (difficult == 0) ? 0 : difficult > 0
    @match_difficult      = difficult.abs
    @resource_probability = probability(@expectation)
    @alpha                = (difficult / Sigma::SCALE)**2.0
  end

  def update_sigma(exp)
    # Missing draw support
    if @expectation
      expectations                              = self.expectations['win_expectation'][exp]
      salpha                                    = ((@resource_probability - 1).abs) * @alpha
      self.doubt                                = self.doubt - (self.doubt * salpha)
      self.expectations['win_expectation'][exp] = expectations + 1
    else
      expectations                               = self.expectations['lost_expectation'][exp]
      salpha                                     = @resource_probability * @alpha
      self.doubt                                 = self.doubt + (self.doubt * salpha)
      self.expectations['lost_expectation'][exp] = expectations + 1
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
      mult = (k == 'wins') ? w : nil
      mult ||= (k == 'losses') ? l : d

      v[:we] = mult*(self.expectations['win_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:le] = mult*(self.expectations['lost_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:de] = mult*(self.expectations['draw_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
    end
    
    all_probabilities = expectations[result][:we]+expectations[result][:le]+expectations[result][:de]
    probability       = expectations[result][:we] / ((all_probabilities == 0) ? 1 : all_probabilities)

    (probability == 0.0) ? 0.5 : probability
  end

  def self.ranking
    #TODO
  end