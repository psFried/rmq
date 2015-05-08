require 'spec_helper'

describe RMQ::Queue do
  SAMPLE_QUEUE = SpecHelper::DATA[:sample_queue]

  before(:each) do
    @qm = RMQ::QueueManager::connect(SpecHelper::DATA[:queue_manager])

    @qm.delete_queue(SAMPLE_QUEUE) unless @qm.find_queue(SAMPLE_QUEUE).nil?
    @queue = @qm.create_queue(SAMPLE_QUEUE)
  end

  after(:each) do
    begin
      @qm.delete_queue(SAMPLE_QUEUE)
    rescue
      puts "Cannot delete #{SAMPLE_QUEUE}"
    end
    @qm.disconnect if !@qm.nil?
  end

  it "should put a message on a queue" do
    @queue.put_message("sample message")
    @queue.depth.should == 1
  end

  it "should read a message from a queue" do
    @queue.put_message("I want to read this back")
    @queue.get_message_payload.should == "I want to read this back"
  end

  it "should put a message on a queue and use a reply queue name" do
    @queue.put_message("I want to read this back", "REPLY_QUEUE")
    message = @queue.get_message
    message.should_not be_nil
    message.reply_queue_name.should == "REPLY_QUEUE"
  end

  it "should time out waiting for a message" do
    lambda { @queue.get_message({:timeout => 2}) }.should raise_error(RMQ::RMQTimeOutError)
  end

  it "should time out waiting for a message and not return any payload" do
    lambda { @queue.get_message_payload({:timeout => 2}) }.should raise_error(RMQ::RMQTimeOutError)
  end

  it "should find a message by id" do
    message_id = @queue.put_message("I want to read this back")
    message_id.should_not be_nil

    message = @queue.find_message_by_id(message_id)
    message.payload.should == "I want to read this back"
  end

  it "should find not a message by id" do
    lambda { @queue.find_message_by_id([1,2,3]) }.should raise_error(RMQ::RMQMessageNotFoundException)
  end

  it "should time out when finding a message by id" do
    message_id = [1,2,3]
    lambda { @queue.find_message_by_id(message_id, {:timeout => 2}) }.should raise_error(RMQ::RMQTimeOutError)
  end

  context 'Browse Queue' do

    it 'should list all messages on the queue' do
      timestamp = Time.now.to_s
      @queue.put_message('Everybody' + timestamp)
      @queue.put_message('Needs Somebody' + timestamp)
      @queue.put_message('To Love' + timestamp)

      messages = @queue.browse

      expect(messages.size).to eq(3)
      expect(messages[0].payload).to eq('Everybody' + timestamp)
      expect(messages[1].payload).to eq('Needs Somebody' + timestamp)
      expect(messages[2].payload).to eq('To Love' + timestamp)

      expect(@queue.depth).to eq(3)
    end

  end

  context 'dealing with headers' do

    it 'should put a message with headers onto the queue' do
      body = "test body"
      headers = {'key1'=> 'val1', 'key2' => 'val2'}
      @queue.put_message(body)
    end

  end

end
