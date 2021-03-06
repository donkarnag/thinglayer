class Thing < ActiveRecord::Base
	belongs_to :user
    belongs_to :zone
    has_many :events
    acts_as_list :scope => :zone

    before_destroy :remove_firebase
    
    def switch_value 
    end
    def lock_value
    end
    def dimmer_value
    end
    
    
    # Gather events from firebase by device

    def firebase_events
    
        client = Firebase::Client.new(ENV["FIREBASE_URL"])
        
        if self.device_type == "temperatureMeasurement"
            temps = client.get("events/"+self.uid+"/temperature")
            return temps.body
        elsif self.device_type == "switch"
            switches = client.get("events/"+self.uid+"/switch")
            return switches.body
        elsif self.device_type == "dimmer"
            dimmers = client.get("events/"+self.uid+"/dimmder")
            return dimmers.body
        elsif self.device_type == "relativeHumidityMeasurement"
            hums = client.get("events/"+self.uid+"/humidity")
            return hums.body
        elsif self.device_type == "motion"
            mots = client.get("events/"+self.uid+"/motion")
            return mots.body
        elsif self.device_type == "illuminant"
            illums = client.get("events/"+self.uid+"/illuminant")
            return illums.body
        elsif self.device_type == "contact"
            conts = client.get("events/"+self.uid+"/contact")
            return conts.body
        elsif self.device_type == "battery"
            bats = client.get("events/"+self.uid+"/battery")
            return bats.body
        elsif self.device_type == "lock"
            locks = client.get("events/"+self.uid+"/lock")
            return locks.body
        elsif self.device_type == "power"
            pows = client.get("events/"+self.uid+"/power")
            return pows.body
        elsif self.device_type == "energy"
            engs = client.get("events/"+self.uid+"/enrgy")
            return engs.body
        elsif self.device_type == "presence"
            pres = client.get("events/"+self.uid+"/presence")
            return pres.body

        end 
            
    end

    
    # Import events into local mysql from firebase 
    
    def import_events
        unless self.firebase_events == nil
            self.firebase_events.to_hash.each do |x|
                event = Event.find_or_initialize_by(name: x[0])
                event.update(name: x[0])
                event.update(date: x[1]["date"])
                event.update(value: x[1]["value"])
                event.update(thing_id: self.id)
                event.save!
            end
     
        end 

    end 


    # Delete device specific events from firebase 

    def remove_firebase
        client = Firebase::Client.new(ENV["FIREBASE_URL"])
        
        if self.device_type == "temperatureMeasurement"
            client.delete("events/"+self.uid+"/temperature")
        elsif self.device_type == "switch"
            client.delete("events/"+self.uid+"/switch")
        elsif self.device_type == "dimmer"
            client.delete("events/"+self.uid+"/dimmder")
        elsif self.device_type == "relativeHumidityMeasurement"
            client.delete("events/"+self.uid+"/humidity")
        elsif self.device_type == "motion"
            client.delete("events/"+self.uid+"/motion")
        elsif self.device_type == "illuminant"
            client.delete("events/"+self.uid+"/illuminant")
        elsif self.device_type == "contact"
            client.delete("events/"+self.uid+"/contact")
        elsif self.device_type == "battery"
            client.delete("events/"+self.uid+"/battery")
        elsif self.device_type == "lock"
            client.delete("events/"+self.uid+"/lock")
        elsif self.device_type == "power"
            client.delete("events/"+self.uid+"/power")
        elsif self.device_type == "energy"
            client.delete("events/"+self.uid+"/energy")
        elsif self.device_type == "presence"
            client.delete("events/"+self.uid+"/presence")
        end 
    end
    
    # Remove a device from firebase completely (Used when user deletes a device or their account)

    def remove_firebase_item
        client = Firebase::Client.new(ENV["FIREBASE_URL"])
        client.delete("events/"+self.uid)
    end 
    


    # Methods for collecting device information from SmartThings

    def switch_details
        @user ||= User.find(user_id)
        @user.smartthings.show_switch(self.uid)
    end

    def contact_details
        @user ||= User.find(user_id)
        @user.smartthings.show_contact(self.uid)
    end

    def power_details
        @user ||= User.find(user_id)
        @user.smartthings.show_power(self.uid)
    end

    def energy_details
        @user ||= User.find(user_id)
        @user.smartthings.show_energy(self.uid)
    end

    def presence_details
        @user ||= User.find(user_id)
        @user.smartthings.show_presence(self.uid)
    end

    def dimmer_details
        @user ||= User.find(user_id)
        @user.smartthings.show_dimmer(self.uid)
    end


     def motion_details
        @user ||= User.find(user_id)
        @user.smartthings.show_motion(self.uid)
    end
    def motion_events
        @user ||= User.find(user_id)
        @user.smartthings.motion_events(self.uid)
    end
    def lock_details
        @user ||= User.find(user_id)
        @user.smartthings.show_lock(self.uid)
    end 
    def illuminant_details
        @user ||= User.find(user_id)
        @user.smartthings.show_illuminant(self.uid)
    end 

    def battery_details
        @user ||= User.find(user_id)
        @user.smartthings.show_battery(self.uid)
    end 
    def temperature_details
        @user ||= User.find(user_id)
        @user.smartthings.show_temperature(self.uid)
    end
    def humidity_details
        @user ||= User.find(user_id)
        @user.smartthings.show_humidity(self.uid)
    end
    def  lock_details
        @user ||= User.find(user_id)
        @user.smartthings.show_lock(self.uid)
    end
      
    
    # Enqueue a value retrieval from ST and send it to firebase. Useful for devices that do not update very often or when a user intially logs in. 
    # You can find the workers in /thinglayer/app/workers

    def device_value        
           if self.device_type == "dimmer"
                Resque.enqueue(GetDimmer, self.id)
                return nil
            elsif self.device_type == "temperatureMeasurement" 
                Resque.enqueue(GetTemperature, self.id)
                return nil 
            elsif self.device_type == "relativeHumidityMeasurement" 
                Resque.enqueue(GetHumidity, self.id)
                return nil
            elsif self.device_type == "motion" 
                Resque.enqueue(GetMotion, self.id)
                return nil
            elsif self.device_type == "contact" 
                Resque.enqueue(GetContact, self.id)
                return nil
            elsif self.device_type == "lock" 
                Resque.enqueue(GetLock, self.id)
                return nil
            elsif self.device_type == "battery" 
                Resque.enqueue(GetBattery, self.id)
                return nil
            elsif self.device_type == "switch" 
                Resque.enqueue(GetSwitch, self.id)
                return nil
            elsif self.device_type == "illuminant" 
                Resque.enqueue(GetIlluminant, self.id)
                return nil
            elsif self.device_type == "power" 
                Resque.enqueue(GetPower, self.id)
                return nil
            elsif self.device_type == "energy" 
                Resque.enqueue(GetEnergy, self.id)
                return nil
            elsif self.device_type == "presence" 
                Resque.enqueue(GetPresence, self.id)
                return nil
            end
    end
    

    # Format the display output for a device type 
    
    def display_type
        if self.device_type == "relativeHumidityMeasurement" 
            return "Humidity"
        elsif self.device_type == "temperatureMeasurement"
            return "Temperature"
        elsif self.device_type == "contact"
            return "Contact"
        elsif self.device_type == "illuminant"
            return "Illuminance"
        elsif self.device_type == "battery"
            return "Battery"
        elsif self.device_type == "lock"
            return "Lock"
        elsif self.device_type == "switch"
            return "Switch"
        elsif self.device_type == "dimmer"
            return "Dimmer"
        elsif self.device_type == "motion"
            return "Motion"
        end
            
    end
end
