class SyncManager
  attr_accessor :user_id, :authenticator

  def initialize database, user_id = nil
    @database = database
    @user_id = user_id
  end

  def sync_url
    @sync_url ||= NSURL.URLWithString(Config::SyncGateway::URL)
  end

  def start_replication
    @pull = @database.createPullReplication(sync_url)
    @pull.continuous = true

    @push = @database.createPushReplication(sync_url)
    @push.continuous = true

    listen_for_replication_events @pull
    listen_for_replication_events @push

    authenticator.register_credentials_for_replications [@push, @pull]

    # re-start the replications
    @pull.stop
    @pull.start
    @push.stop
    @push.start
  end

  def authenticator= authenticator
    @authenticator = authenticator
    authenticator.sync_manager = self
  end

  def listen_for_replication_events replication
    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector:"progress:",
                                                   name:KCBLReplicationChangeNotification,
                                                   object:replication)
  end

  def progress notification_center
    active = false
    completed = 0
    total =  0
    status = KCBLReplicationStopped
    error_ptr = Pointer.new(:object)

    [@push, @pull].each do |replication|
      status = [status, replication.status].max
      error_ptr = replication.lastError unless error_ptr && error_ptr[0]
      if replication.status == KCBLReplicationActive
        active = true
        completed += replication.completedChangesCount
        total += replication.changesCount
      end
    end

    puts "SyncManager: error: #{error_ptr[0].localizedDescription}" if error_ptr && error_ptr[0]
    puts "SyncManager: active = #{active}, status = #{status}, #{completed}/#{total}"
  end
end

