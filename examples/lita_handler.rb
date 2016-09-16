module Lita
  module Handlers
    class ElasticBeanstalk < Handler
      config :aws_region, default: ENV['AWS_REGION'] || 'us-east-1'

      route(/^eb info/, :eb_info, command: true, restrict_to: :deploy_group, help: { 'eb info' => 'List info about EB applications' })

      def eb_info(response)
        _action, app_slug = response.args
        at = []
        apps = app_slug ? { app_slug => fetch_apps[app_slug] } : fetch_apps
        apps.each_with_index do |app, i|
          hash = {
            color: '#00F',
            pretext: "*[#{app.first}]* info for *#{app.last['description']}*\n
            *release*\trun\t`!eb release #{app.first} GITHUB_BRANCH VERSION_TAG`\n
            *deploy*\trun\t`!eb deploy #{app.first} VERSION_TAG`\n
            *switch*\trun\t`!eb switch #{app.first}`\n
            *status*\trun\t`!eb status #{app.first}`\n
            *logs*\trun\t`!eb logs #{app.first} APP_STAGE(DEFAULT=current)`\n
            *rake*\trun\t`!eb rake #{app.first} RAKE_TASK`\n
            *URL*\t #{app.last['app']}\n",
            mrkdwn_in: ['text', 'pretext'],
            fallback: "#{i + 1}. #{app.last['app']} [#{app.first}]"
          }
          at.push Lita::Adapters::Slack::Attachment.new('', hash)
        end
        robot.chat_service.send_attachment(response.room, at)
      end

      Lita.register_handler(ElasticBeanstalk)
    end
  end
end
