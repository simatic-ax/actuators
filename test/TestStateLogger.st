USING AxUnit.Assert;
USING System.Strings;
NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    CLASS TestStateLogger
        VAR
            _o, _oStateLess  : StateLogger;
            _msgBuffer : ARRAY[2..4] OF LogMessage;
        END_VAR

        {TestSetup}
        METHOD PUBLIC Setup
            _o := _oStateLess;
            _o.MsgBuffer := REF(_msgBuffer);
        END_METHOD


        {Test}
        METHOD PUBLIC TestWriteLog
            VAR
                msg : STRING := 'Test message';
                loglevel : LogLevel := LogLevel#Info;
            END_VAR

            _o.SetLogLevel(loglevel := LogLevel.Info);
            _o.WriteLog(msg := msg, loglevel := loglevel);
            IsTrue(condition := _o.MsgBuffer^[2].message = msg);
        END_METHOD


        {Test}
        METHOD PUBLIC TestCircularBuffer
            VAR
                i : DINT;
                msg : STRING;
                loglevel : LogLevel := LogLevel#Info;
            END_VAR

            _o.SetLogLevel(loglevel := loglevel);
            FOR i := 2 TO 4 DO
                msg := CONCAT('Message ', Conversion.Integer.ToString(i));
                _o.WriteLog(msg := msg, loglevel := loglevel);
            END_FOR;
            Equal(actual := _o.MsgBuffer^[2].message, expected := 'Message 2');
            Equal(actual := _o.MsgBuffer^[3].message, expected := 'Message 3');
            Equal(actual := _o.MsgBuffer^[4].message, expected := 'Message 4');
            FOR i := 6 TO 8 DO
                msg := CONCAT('Message ', Conversion.Integer.ToString(i));
                _o.WriteLog(msg := msg, loglevel := loglevel);
            END_FOR;
            Equal(actual := _o.MsgBuffer^[2].message, expected := 'Message 6');
            Equal(actual := _o.MsgBuffer^[3].message, expected := 'Message 7');
            Equal(actual := _o.MsgBuffer^[4].message, expected := 'Message 8');
        END_METHOD
    END_CLASS

END_NAMESPACE
