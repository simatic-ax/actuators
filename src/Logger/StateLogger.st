NAMESPACE Simatic.Ax.Actuators

    CLASS StateLogger
        IMPLEMENTS itfLogger
        VAR PUBLIC
            MsgBuffer : REF_TO ARRAY[*] OF LogMessage;
        END_VAR
        VAR PROTECTED
        END_VAR
        VAR PRIVATE
            _pos : DINT;
            _ll, _ul : DINT := -1;
            _capacity : DINT;
            _enabledLoglevel : LogLevel;
        END_VAR

        METHOD PUBLIC Init
            IF (MsgBuffer <> NULL) THEN
                _ll := LOWER_BOUND(MsgBuffer^, 1);
                _ul := UPPER_BOUND(MsgBuffer^, 1);
                _capacity := _ul - _ll + 1;
                _pos := _ll;
            END_IF;
        END_METHOD

        METHOD PUBLIC WriteLog
            VAR_INPUT
                msg : STRING;
                loglevel : LogLevel;
            END_VAR
            VAR_TEMP
                _data : REF_TO LogMessage;
                _timestamp : DATE_AND_TIME;
            END_VAR
            IF (loglevel < _enabledLoglevel) THEN
                RETURN;
            END_IF;
            IF (_ll = -1 OR _ul = -1) THEN
                THIS.Init();
            END_IF;
            _data := REF(MsgBuffer^[_pos]);
            _data^.message := msg;
            _data^.timestamp := _timestamp;
            _pos := (_pos + 1);
            IF (_pos > _ul) THEN
                _pos := _ll;
            END_IF;
        END_METHOD

        METHOD PUBLIC SetLogLevel
            VAR_INPUT
                loglevel : LogLevel;
            END_VAR
            ;
        END_METHOD
    
        METHOD PUBLIC Capacity : DINT
            Capacity := _capacity;
        END_METHOD
    END_CLASS

    TYPE
        LogMessage : STRUCT
            timestamp : DATE_AND_TIME;
            message : STRING;
        END_STRUCT;
    END_TYPE

END_NAMESPACE
