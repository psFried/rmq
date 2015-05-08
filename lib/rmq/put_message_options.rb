module RMQ
  module MQClient

    class PutMessageOptions < FFI::Struct
      MQPMO_STRUC_ID    = "PMO "
      MQPMO_VERSION_1   = 1
      MQPMO_SYNCPOINT   = 0x00000002

      layout  :StrucId, [:char, 4],
        :Version, :int32,
        :Options, :int32,
        :Timeout, :int32,
        :Context, :pointer,
        :KnownDestCount, :int32,
        :UnknownDestCount, :int32,
        :InvalidDestCount, :int32,
        :ResolvedQName, [:char, 48],
        :ResolvedQMgrName, [:char, 48],
        :RecsPresent, :int32,
        :PutMsgRecFields, :int32,
        :PutMsgRecOffset, :int32,
        :ResponseRecOffset, :int32,
        :PutMsgRecPtr, :pointer,
        :ResponseRecPtr, :pointer,
        :OriginalMsgHandle, :int64,
        :NewMsgHandle, :int64,
        :Action, :int32,
        :PubLevel, :int32
    end
  end
end
