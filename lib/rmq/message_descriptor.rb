module RMQ
  module MQClient

    class MessageDescriptor < FFI::Struct
      MQMD_STRUC_ID         = "MD  "
      MQMD_VERSION_1        = 1
      MQEI_UNLIMITED        = -1
      MQRO_NONE             = 0x00000000
      MQMT_DATAGRAM         = 8
      MQPER_PERSISTENT      = 1

      MSG_ID_LENGTH = 24

      layout  :StrucId, [:char, 4],
        :Version, :int32,
        :Report, :int32,
        :MsgType, :int32,
        :Expiry, :int32,
        :Feedback, :int32,
        :Encoding, :int32,
        :CodedCharSetId, :int32,
        :Format, [:char, 8],
        :Priority, :int32,
        :Persistence, :int32,
        :MsgId, [:uint8, MSG_ID_LENGTH],
        :CorrelId, [:char, 24],
        :BackoutCount, :int32,
        :ReplyToQ, [:char, 48],
        :ReplyToQMgr, [:char, 48],
        :UserIdentifier, [:char, 12],
        :AccountingToken, [:char, 32],
        :ApplIdentityData, [:char, 32],
        :PutApplType, :int32,
        :PutApplName, [:char, 28],
        :PutDate, [:char, 8],
        :PutTime, [:char, 8],
        :ApplOriginData, [:char, 4],
        :GroupId, [:char, 24],
        :MsgSeqNumber, :int32,
        :Offset, :int32,
        :MsgFlags, :int32,
        :OriginalLength, :int32
    end

  end
end
