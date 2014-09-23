class SeamEffort < ActiveRecord::Base
  serialize :data, Hash

  def to_effort
    Seam::Effort.find effort_id
  end

end
