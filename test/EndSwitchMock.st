USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Actuators

    CLASS EndSwitchMockActivated IMPLEMENTS itfEndswitch

        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := TRUE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    END_CLASS

    CLASS EndSwitchMockHasReached IMPLEMENTS itfEndswitch

        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := TRUE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasReached : BOOL
            HasReached := TRUE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    END_CLASS

    CLASS EndSwitchMockHasLeft IMPLEMENTS itfEndswitch

        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := TRUE;
            ;
        END_METHOD
    
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    END_CLASS

    CLASS EndSwitchMockNotActivated IMPLEMENTS itfEndswitch

        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    END_CLASS
END_NAMESPACE
