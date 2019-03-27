# Design csv reader for the file
require 'csv'

User.all.delete_all
Event.all.delete_all

user_file_csv = File.read("db/data/users.csv")
email_file_csv = File.read("db/data/events.csv")
users_csv = CSV.parse(user_file_csv, headers: true)
events_csv = CSV.parse(email_file_csv, headers: true)

users_csv.each do |user_csv|
  user = User.create(username: user_csv["username"],
    email: user_csv["username"], phone: user_csv["phone"])
    events_csv.each do |event_csv|
      if event_csv["users#rsvp"]
        if event_csv["users#rsvp"].include? user[:username]
          event_rsvp_arr = events_csv["users#rsvp"].split(/[;]/)[0]
          event_rsvp_status = 'No'
          event_rsvp_arr.each do |rsp_arr|
            if rsp_arr
              if rsp_arr.include? user[:username]
                event_rsvp_status = rsp_arr.split(/#/)[1]
              end
            end
          end
          current_date_time = Time.now
          event_completed = false
          if current_date_time >= event_csv["endtime"]
            event_completed = true
          end
          event_user_previous_check =
          Event.where(start_time: event_csv[:starttime],
            user_id: user[:id])
          last_previous_check_rsvp = event_rsvp_status
          if event_user_previous_check
             event_user_previous_check.update_all(rsvp: 'No')
             last_previous_check_rsvp = 'Yes'
          end
          endtime = event_csv["endtime"]
          if event_csv["allday"] == "TRUE"
            endtime = ''
          end
          Event.create({
            title: event_csv["title"],
            description: event_csv["description"],
            start_time: event_csv["starttime"],
            end_time: endtime,
            event_completed: event_completed,
            rsvp: last_previous_check_rsvp,
            all_day: event_csv["allday"],
            user_id: user[:id]
          })
        end
      end
    end
end
