require 'seam'
require_relative "active_record/version"

module Seam
  module ActiveRecord
    def self.load
      overwrite_the_persistence_layer
    end

    def self.overwrite_the_persistence_layer
      Seam::Persistence.class_eval do
        def self.find_by_effort_id effort_id
          record = SeamEffort.where(effort_id: effort_id).first
          return nil unless record
          Seam::Effort.parse record.data
        end

        def self.find_all_pending_executions_by_step step
          SeamEffort.where(next_step: step)
                    .where('next_execute_at >= ?', Time.now)
                    .map do |record|
                      Seam::Effort.parse record.data
                    end
        end

        #def self.find_something_to_do
          #record = Seam::Mongodb.collection
                     #.find( { 
                              #next_execute_at: { '$lte' => Time.now }, 
                              #next_step:       { '$ne'  => nil },
                              #complete:        { '$in'  => [nil, false] },
                            #} )
                     #.first
          #return [] unless record
          #[record].map do |x|
                         #-> do
                           #record = Seam::Mongodb.collection.find( { '_id' => x['_id'] } ).first
                           #Seam::Effort.parse record
                         #end.to_object
                       #end
        #end

        def self.save effort
          effort = SeamEffort.where(effort_id: effort.id).first
          effort.next_step = effort.next_step
          effort.next_execute_at = effort.next_execute_at
          effort.complete = effort.complete
          effort.data = effort.to_hash
          effort.save!
        end

        def self.create effort
          effort = SeamEffort.new
          effort.effort_id = efforrt.id
          effort.next_step = effort.next_step
          effort.next_execute_at = effort.next_execute_at
          effort.complete = effort.complete
          effort.data = effort.to_hash
          effort.save!
        end

        def self.all
          SeamEffort.all
        end

        def self.destroy
          SeamEffort.delete_all
        end
      end
    end
  end
end
