module Bosh::HealthMonitor
  module Events
    class AppInfo < Base

        def initialize(attributes = {})
           super #change attributes to @attributes,@logger,@errors
           @kind = :appinfo
           @metrics = []
           puts attributes
           @droplet = attributes['droplet']
           @instance = attributes['instance']
           @index = attributes['index']
           @state = attributes['state']
           @stats = attributes['stats']
           #@timestamp = Time.at(@attributes["state_timestamp"])
           @name = @stats['name']
           @uris = @stats['uris']
           @host = @stats['host']
           @port = @stats['port']
           @uptime = @stats['uptime']
           @mem_quota = @stats['mem_quota']
           @disk_quota = @stats['disk_quota']
           @fds_quota = @stats['disk_quota']
           @usage = @stats['usage']
           time = @usage['time']
           times = time.split()
           days = times[0].split('-')
           secs = times[1].split(':')
           @timestamp = Time.mktime(days[0],days[1],days[2],secs[0],secs[1],secs[2])
           #puts @timestamp
           @tags = {}
           @tags['name']=@name
           @tags['index'] = @index
           populate_app_metrics
        end

        def validate
          add_error("id is missing") if @id.nil?
          add_error("timestamp is missing") if @timestamp.nil?

          if @timestamp && !@timestamp.kind_of?(Time)
            add_error("timestamp is invalid")
          end
        end

        def to_hash
          {
              :kind => "appinfo",
              :timestamp => @timestamp.to_i,
              :app => @name,
              :index => @index,
              :state => @state,
              :vitals => @usage
          }
        end

        def to_json
          Yajl::Encoder.encode(self.to_hash)
        end

        def to_plain_text
          self.short_description
        end

        def metrics
           @metrics
        end

        def populate_app_metrics
          add_metric("appinfo.cpu.percenttotal",@usage['cpu'])
          add_metric("appinfo.mem.percent", @usage['mem'].to_f/@mem_quota.to_f)
          add_metric("appinfo.mem.kb",@usage['mem'].to_i/1024)
          add_metric("appinfo.disk.percent",@usage['disk'].to_f/@disk_quota.to_f)
          add_metric("appinfo.disk.kb",@usage['disk'].to_i/1024)
          add_metric("appinfo.state", getState(@state))
          #add_metric("appinfo.uris",@uris) #only a numnerc number is good
          #add_metric("appinfo.host.port",@host.to_s+":"+@port.to_s)
        end

        def add_metric(name, value)
          puts "#{name}:#{value}:#{@tags}"
          @metrics << Metric.new(name, value, @timestamp.to_i, @tags) if value
        end

        def getState(strState)
            state = -1
            case strState
            when 'BORN'
            state = 0
            when 'STARTING'
            state = 1
            when 'RUNNING'
            state = 2
            when 'STOPPING'
            state = 3
            when 'STOPPED'
            state = 4
            when 'CRASHED'
            state = 5
            when 'DELETED'
            state = 6
            when 'RESUMING'
            state = 7
            when 'EVACUATING'
            state = 8
            end
            state
          end
        end
    end
  end