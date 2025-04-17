
NAMESPACE Simatic.Ax.Actuators

    
    INTERFACE itfLogger
       
        METHOD WriteLog
            VAR_INPUT
                msg : STRING;
                loglevel : LogLevel;
            END_VAR
        END_METHOD
        METHOD SetLogLevel
            VAR_INPUT
                loglevel : LogLevel;
            END_VAR
            
        END_METHOD
        METHOD Capacity : DINT
        END_METHOD
    END_INTERFACE

    TYPE
        LogLevel : INT (None := 1, Info := 2, Debug := 99) := None;
    END_TYPE
END_NAMESPACE
