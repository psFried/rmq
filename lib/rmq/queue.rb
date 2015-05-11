require_relative 'message_headers'

module RMQ

  class Queue
    include MQClient

    # TODO add some caching for the queue handle

    def initialize(queue_manager, name)
      @queue_manager = queue_manager
      @queue_name = name
    end

    # Puts a message onto the queue. A reply to queue name can be specified.
    def put_message(payload, reply_queue_name = "")
      @queue_handle = open_queue(@queue_manager.connection_handle, @queue_name, Constants::MQOO_OUTPUT) if @queue_handle.nil?

      message_id = put_message_on_queue(@queue_manager.connection_handle, @queue_handle, payload, reply_queue_name)

      close_queue(@queue_manager.connection_handle, @queue_handle, Constants::MQCO_NONE)
      @queue_handle = nil

      message_id
    end

    def prepare_headers(length)
      message_headers = MessageHeaders.new
      message_headers[:StrucId] = 'RFH '
      message_headers[:Version] = MessageHeaders::MQRFH_VERSION_2
      message_headers[:StrucLength] = MessageHeaders::MQRFH_STRUC_LENGTH_FIXED_2 + length
      message_headers[:Encoding] = MessageHeaders::MQENC_NATIVE
      message_headers[:CodedCharSetId] = MessageHeaders::MQCCSI_INHERIT
      message_headers[:Format] = MessageHeaders::MQFMT_NONE
      message_headers[:Flags] = MessageHeaders::MQRFH_NONE
      message_headers[:NameValueCCSID] = MessageHeaders::MQRFH_NVENC
      message_headers
    end

    def prepare_payload(headers, body)
      headers_string = convert_headers_to_xmlish(headers)
      headers_struct = prepare_headers(headers_string.length)

      

    end

    def convert_headers_to_xmlish(headers_hash)
      headers = headers_hash.collect{|k, v| "<#{k}>#{v}</#{k}>"}.inject(:+)
    end

    def put_message_with_headers(payload, headers, reply_queue_name = "")
      @queue_handle = open_queue(@queue_manager.connection_handle, @queue_name, Constants::MQOO_OUTPUT) if @queue_handle.nil?
      payload = prepare_headers(headers) + payload #
      message_id = put_message_on_queue(@queue_manager.connection_handle, @queue_handle, payload, reply_queue_name)

      close_queue(@queue_manager.connection_handle, @queue_handle, Constants::MQCO_NONE)
      @queue_handle = nil

      message_id
    end

    def depth
      queue_depth(@queue_manager.connection_handle, @queue_name)
    end

    # Gets a message from the queue. A timeout period can be specified in seconds.
    def get_message(options = {})
      @queue_handle = open_queue(@queue_manager.connection_handle, @queue_name, Constants::MQOO_INPUT_SHARED) if @queue_handle.nil?

      begin
        begin_time = Time.now.to_i
        message = get_message_from_queue(@queue_manager.connection_handle, @queue_handle, options)
      rescue RMQException
        end_time = Time.now.to_i

        raise RMQTimeOutError.new if options.has_key?(:timeout) && (end_time - begin_time >= options[:timeout])
      ensure
        close_queue(@queue_manager.connection_handle, @queue_handle, Constants::MQCO_NONE)
        @queue_handle = nil
      end

      message
    end

    # Gets a message from the queue and returns the payload only. A timeout period can be specified
    # in seconds.
    def get_message_payload(options = {})
      message = get_message(options)
      message.payload
    end

    def find_message_by_id(message_id, options = {})
      message = get_message(options.merge({:message_id => message_id}))

      if (message && compare_message_id(message_id, message.message_id))
        return message
      else
        raise RMQMessageNotFoundException.new(message_id)
      end
    end

    private

    def compare_message_id(id1, id2)
      for i in (0..MQClient::MessageDescriptor::MSG_ID_LENGTH-1) do
        return false unless id1[i] == id2[i]
      end
      true
    end
  end
end