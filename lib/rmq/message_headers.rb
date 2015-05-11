module RMQ
  module MQClient

    class MessageHeaders < FFI::Struct
      MQRFH_STRUC_ID              = 'RFH '
      MQRFH_VERSION_2             = 2
      MQRFH_STRUC_LENGTH_FIXED_2  = 36
      MQENC_NATIVE                = 1208 # depends on environment
      MQCCSI_INHERIT              = -2
      MQFMT_NONE                  = '       0' # blanks
      MQRFH_NONE                  = 0
      MQRFH_NVENC                 = 1208

      layout  :StrucId, [:char, 4],
              :Version, :int32,
              :StrucLength, :int32,
              :Encoding, :int32,
              :CodedCharSetId, :int32,
              :Format, [:char, 8],
              :Flags, :int32,
              :NameValueCCSID, :int32 # 1208 for UTF-8
    end
  end
end