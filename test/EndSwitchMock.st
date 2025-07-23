USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Actuators

    /// Mock implementation of an activated endswitch for testing purposes.
    /// Input: None.
    /// Returns: Always returns TRUE for IsActivated, FALSE for all other state queries.
    CLASS EndSwitchMockActivated IMPLEMENTS itfEndswitch

        /// Starts monitoring the endswitch with a specified monitoring time.
        /// Input: Mode - The supervision mode to enable.
        /// Returns: None.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR

            ;
        END_METHOD
    
        /// Checks if the endswitch is currently activated.
        /// Input: None.
        /// Returns: Always TRUE to simulate an activated endswitch.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := TRUE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been reached.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been left.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        /// Checks if the monitoring time has elapsed.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    
        /// Returns the error status of the endswitch.
        /// Input: None.
        /// Returns: Default supervision error state.
        METHOD PUBLIC GetError : SuperVisionError
            ;
        END_METHOD
    END_CLASS

    /// Mock implementation of an endswitch that has been reached for testing purposes.
    /// Input: None.
    /// Returns: TRUE for IsActivated and HasReached, FALSE for other state queries.
    CLASS EndSwitchMockHasReached IMPLEMENTS itfEndswitch

        /// Starts monitoring the endswitch with a specified monitoring time.
        /// Input: Mode - The supervision mode to enable.
        /// Returns: None.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR
            ;
        END_METHOD

        /// Checks if the endswitch is currently activated.
        /// Input: None.
        /// Returns: Always TRUE to simulate an activated endswitch.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := TRUE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been reached.
        /// Input: None.
        /// Returns: Always TRUE to simulate a reached endswitch.
        METHOD PUBLIC HasReached : BOOL
            HasReached := TRUE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been left.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        /// Checks if the monitoring time has elapsed.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    
        /// Returns the error status of the endswitch.
        /// Input: None.
        /// Returns: Default supervision error state.
        METHOD PUBLIC GetError : SuperVisionError
            ;
        END_METHOD
    END_CLASS

    /// Mock implementation of an endswitch that has been left for testing purposes.
    /// Input: None.
    /// Returns: TRUE for HasLeft, FALSE for other state queries.
    CLASS EndSwitchMockHasLeft IMPLEMENTS itfEndswitch

        /// Starts monitoring the endswitch with a specified monitoring time.
        /// Input: Mode - The supervision mode to enable.
        /// Returns: None.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR

            ;
        END_METHOD
    
        /// Checks if the endswitch is currently activated.
        /// Input: None.
        /// Returns: Always FALSE to simulate a deactivated endswitch.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := FALSE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been reached.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been left.
        /// Input: None.
        /// Returns: Always TRUE to simulate a left endswitch.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := TRUE;
            ;
        END_METHOD
    
        /// Checks if the monitoring time has elapsed.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    
        /// Returns the error status of the endswitch.
        /// Input: None.
        /// Returns: Default supervision error state.
        METHOD PUBLIC GetError : SuperVisionError
            ;
        END_METHOD
    END_CLASS

    /// Mock implementation of a non-activated endswitch for testing purposes.
    /// Input: None.
    /// Returns: FALSE for all state queries to simulate an inactive endswitch.
    CLASS EndSwitchMockNotActivated IMPLEMENTS itfEndswitch

        /// Starts monitoring the endswitch with a specified monitoring time.
        /// Input: Mode - The supervision mode to enable.
        /// Returns: None.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR

            ;
        END_METHOD

        /// Disables monitoring of the endswitch.
        /// Input: None.
        /// Returns: None.
        METHOD PUBLIC DisableMonitoring
            ;
        END_METHOD
    
        /// Checks if the endswitch is currently activated.
        /// Input: None.
        /// Returns: Always FALSE to simulate an inactive endswitch.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := FALSE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been reached.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasReached : BOOL
            HasReached := FALSE;
            ;
        END_METHOD
    
        /// Checks if the endswitch has been left.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := FALSE;
            ;
        END_METHOD
    
        /// Checks if the monitoring time has elapsed.
        /// Input: None.
        /// Returns: Always FALSE for this mock.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
    
        /// Returns the error status of the endswitch.
        /// Input: None.
        /// Returns: Default supervision error state.
        METHOD PUBLIC GetError : SuperVisionError
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE
