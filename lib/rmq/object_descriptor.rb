module RMQ
  module MQClient

    class ObjectDescriptor < FFI::Struct
      MQOD_STRUC_ID             = "OD  "
      MQOD_VERSION_1            = 1
      MQOD_VERSION_4            = 4

      # Object Types
      MQOT_NONE       = 0
      MQOT_Q          = 1
      MQOT_NAMELIST   = 2
      MQOT_PROCESS    = 3
      MQOT_STORAGE_CLASS = 4
      MQOT_Q_MGR      = 5
      MQOT_CHANNEL    = 6
      MQOT_AUTH_INFO  = 7
      MQOT_TOPIC      = 8
      MQOT_CF_STRUC   = 10
      MQOT_LISTENER   = 11
      MQOT_SERVICE    = 12
      MQOT_RESERVED_1 = 999
      
      
      layout  :StrucId, [:char, 4],
        :Version, :int32,
        :ObjectType, :int32,
        :ObjectName, [:char, 48],
        :ObjectQMgrName, [:char, 48],
        :DynamicQName, [:char, 48],
        :AlternateUserId, [:char, 12],
        :RecsPresent, :int32,
        :KnownDestCount, :int32,
        :UnknownDestCount, :int32,
        :InvalidDestCount, :int32,
        :ObjectRecOffset, :int32,
        :ResponseRecOffset, :int32,
        :ObjectRecPtr, :pointer,
        :ResponseRecPtr, :pointer
    end
  end
end
