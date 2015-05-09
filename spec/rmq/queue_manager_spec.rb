require 'spec_helper'

describe RMQ::QueueManager do
  SAMPLE_QUEUE = SpecHelper::DATA[:sample_queue]

  context 'Connections' do

    it 'should connect/disconnect to/from local queue manager' do
      qm = RMQ::QueueManager::connect(SpecHelper::DATA[:queue_manager])
      qm.should_not be_nil
      qm.disconnect
    end

    it 'should raise an exception for a wrong queue manager name' do
      lambda { RMQ::QueueManager::connect('INVALID_NAME') }.should raise_error(RMQ::RMQException)
    end

    it 'should warn about missing MQSERVER environment variable' do
      ENV['MQSERVER'] = ''
      lambda { RMQ::QueueManager::connect(SpecHelper::DATA[:queue_manager]) }.should raise_error(RuntimeError)
    end

  end

  context 'Queue Manipulation' do

    before :each do
      @queueManager = RMQ::QueueManager::connect(SpecHelper::DATA[:queue_manager])

      begin
        @queueManager.delete_queue(SAMPLE_QUEUE) if !@queueManager.find_queue(SAMPLE_QUEUE).nil?
      rescue
        puts 'Cannot delete #{SAMPLE_QUEUE}'
      end
    end

    after(:each) do
      @queueManager.disconnect if !@queueManager.nil?
    end

    it 'should create a new queue' do
      queue = @queueManager.create_queue('SAMPLE.QUEUE')
      queue.should_not be_nil

      @queueManager.find_queue('SAMPLE.QUEUE').should_not be_nil

      @queueManager.delete_queue('SAMPLE.QUEUE')
    end

    it 'should find an existing queue' do
      @queueManager.find_queue('SYSTEM.ADMIN.COMMAND.QUEUE').should_not be_nil
    end

    it 'should not find a non-existing queue' do
      @queueManager.find_queue('DOES_NOT_EXIST').should be_nil
    end

    it 'should delete a queue' do
      @queueManager.create_queue(SAMPLE_QUEUE)
      @queueManager.find_queue(SAMPLE_QUEUE).should_not be_nil

      @queueManager.delete_queue(SAMPLE_QUEUE)
      @queueManager.find_queue(SAMPLE_QUEUE).should be_nil
    end

  end

end
