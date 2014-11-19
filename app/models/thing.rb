class Thing < ActiveRecord::Base
	belongs_to :user
    belongs_to :zone
    
     acts_as_list :scope => :zone
    
    
    def switch_details
        @user ||= User.find(user_id)
        @user.smartthings.show_switch(self.uid)
    end

    def dimmer_details
        @user ||= User.find(user_id)
        @user.smartthings.show_dimmer(self.uid)
    end
     def motion_details
        @user ||= User.find(user_id)
        @user.smartthings.show_motion(self.uid)
    end
    def motion_details
        @user ||= User.find(user_id)
        @user.smartthings.show_motion(self.uid)
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
    
    def device_value 
        
            base_uri = 'https://dazzling-heat-3134.firebaseio.com/'
            if self.device_type == "dimmer"
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/level")
                if events.success? 
                    if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.dimmer_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil 
                    
                end
            elsif self.device_type == "temperatureMeasurement" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/temperature")
                if events.success? 
                    if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.temperature_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                    
                end
            elsif self.device_type == "relativeHumidityMeasurement" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/humidity")
                if events.success? 
                    if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.humidity_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                   
                end  
            elsif self.device_type == "motion" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/motion")
                if events.success? 
                   if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.motion_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                   
                end 
            elsif self.device_type == "contact" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/contact")
                if events.success? 
                    if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.contact_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                    
                end 
            elsif self.device_type == "lock" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/lock")
                if events.success? 
                   if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.lock_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                    
                end 
            elsif self.device_type == "battery" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/battery")
                if events.success? 
                    if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.battery_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                end 
            elsif self.device_type == "switch" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/switch")
                if events.success? 
                   if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.switch_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                    
                end     
            elsif self.device_type == "illuminant" 
                firebase = Firebase::Client.new(base_uri)
                events = firebase.get("events/"+self.uid+"/illuminance")
                if events.success? 
                   if events.response.body != "null"
                    event =  JSON.parse(events.response.response_body).to_a
                    event.last.second["value"]
                    else
                        device_event = self.illuminant_details
                        return device_event.parsed_response["value"]
                    end
                else 
                    events = nil
                  
                end 
           
            end
        
   
         


    end






    def switch_value
        self.switch_details.parsed_response["value"]
    end

    def dimmer_value
        self.dimmer_details.parsed_response["value"]
    end

    def motion_value
        self.motion_details.parsed_response["value"]
    end

    def dimmer_value=(val)
        @dimmer_value = val
    end 
end