module Lita
  module Handlers
    class BuildNotifications < Handler

      route(/^build\s+(.+)/, :buildCommand, command: true, help: {
          "build notify <me|room-id>" => "notify you or the given room on build events",
          "build list receivers" => "list all ids of who will be notified",
          "build clear receivers" => "remove all receivers of build events"
      })

      http.post "/build/notify", :postNotification

      def postNotification(request, response)
          data = MultiJson.load(request.body)
          notifyAll("Build: #{data['id']} Status: #{data['status']}")
      end

      def notifyAll(message)
          receivers = getReceivers()
          receivers.each do |receiver|
            target = receiverToTarget(receiver)
            unless target == nil
                robot.send_message(target, message)
            end  
          end
      end

      def buildCommand(response)
          args = response.args
          command = args.shift

          case command
          when "notify"
              addNotification(response, args)
          when "list"
              command = args.shift
              case command
              when "receivers"
                  listReceivers(response, args)
              end
          when "clear"
              command = args.shift
              case command
              when "receivers"
                  clearAllReceivers(response)
              end
          end
      end
      
      def addNotification(response, args)
          currentTargets = getReceivers()

          if args[0] == "me"
              if currentTargets.include? "private:#{response.user.id}" 
                response.reply_privately("You are already on the notify list.")
              else
                currentTargets << "user:#{response.user.id}"
                response.reply_privately("You will be notified of build results.")
              end
          else
              currentTargets << "room:#{args[0]}"
          end

         putReceivers(currentTargets)
      end

      def listReceivers(response, args)
          currentTargets = getReceivers()

          if currentTargets == nil
              response.reply_privately("No one is registered to listen to build updates.")
              return
          end

          response.reply_privately("These people follow my build updates:")
          currentTargets.each do |target|
              type = target.split(':')[0]
              id   = target.split(':')[1]

              if type == "user"
                  user = Lita::User.find_by_id(id)
                  name = user.name
              else
                 room = Lita::Room.find_by_id(id)
                 name = room.name
              end

               response.reply_privately("(#{type}) #{name}")
          end
      end

      def clearAllReceivers(response)
          putReceivers([])
          response.reply_with_mention("All build receivers deleted!")
      end

      def getReceivers() 
          json = redis['notify']
          if json == nil
              return []
          end
          return MultiJson.load(json)
      end

      def putReceivers(recArray)
          json = MultiJson.dump(recArray)
          redis['notify'] = json
      end

      def receiverToTarget(receiver)
          type = receiver.split(':')[0]
          id   = receiver.split(':')[1]

          if type == "user"
              user = Lita::User.find_by_id(id)
              return Source.new(user: user, private_message: true)
          else
              return Source.new(room: id)
          end
      end

      Lita.register_handler(self)
    end
  end
end
