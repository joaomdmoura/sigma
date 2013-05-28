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

    if @expectation == true
      skill_update = self.skill / @alpha
      skill_won    = skill_update/Sigma::SCALE/(Sigma::SCALE+match_difficult)
    else
      skill_won = self.skill * @alpha
    end

    self.skill = self.skill + skill_won

    update_sigma(true)
    self.increment :wins
    self.save
  end

  def lost(match_difficult)
    define_match_data(match_difficult)

    if !@expectation
      skill_update = self.skill / @alpha
      skill_lost   = skill_update/Sigma::SCALE/(Sigma::SCALE+match_difficult.abs)
    else
      skill_lost = self.skill * @alpha
    end

    self.skill = self.skill - skill_lost

    update_sigma(false)
    self.increment :losses
    self.save
  end

  def define_match_data(difficult)
    @expectation          = (difficult == 0) ? 0 : difficult > 0
    @resource_probability = probability(@expectation)
    difficult             = (difficult == 0) ? 2.5*Sigma::SCALE/100 : difficult.abs
    @alpha                = difficult / Sigma::SCALE
  end

  def update_sigma(exp)
    exp_result                         = (@expectation == true) ? 'win_expectation' : nil
    exp_result                         ||= (@expectation == false) ? 'lost_expectation' : 'draw_expectation'
    result                             = (exp == true) ? 'wins' : nil
    result                             ||= (exp == false) ? 'losses' : 'draws'

    expectations                       = self.expectations[exp_result][result]
    self.expectations[exp_result][exp] = expectations + 1

    if @expectation == exp
      salpha     = (1 - @resource_probability) * @alpha
      self.doubt = self.doubt - self.doubt * salpha
    else
      salpha     = @resource_probability * @alpha
      self.doubt = self.doubt + self.doubt * salpha
    end
  end

  def probability(expectation)
    result       = (@expectation == true) ? 'wins' : nil
    result       ||= (@expectation == false) ? 'losses' : 'draws'

    exp_result   = (@expectation == true) ? :we : nil
    exp_result   ||= (@expectation == false) ? :le : :de

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
    probability       = expectations[result][exp_result] / ((all_probabilities == 0) ? 1 : all_probabilities)

    (probability == 0) ? 0.25 : probability
  end