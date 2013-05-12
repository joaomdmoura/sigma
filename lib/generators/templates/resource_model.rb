scope :ranking, select("<%= @model_name.pluralize %>.*")
    .select("(<%= @model_name.pluralize %>.skill - 3 * <%= @model_name.pluralize %>.doubt) as rating")
    .order("rating DESC")

def rating
  @rating ||= self[:rating] || self.skill - 3 * self.doubt
end