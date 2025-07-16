USING NotificationService.ErrorHandling;
USING System.Timer;
USING Simatic.Ax.IO.Input;
USING NotificationService.ErrorHandling;
NAMESPACE Simatic.Ax.Actuators    
    /// Class representing an endswitch, implementing the itfEndswitch interface.
    /// Input: None.
    /// Returns: Provides supervision and monitoring capabilities for an endswitch.
    CLASS BooleanEndswitch EXTENDS ErrorProviderBase IMPLEMENTS itfEndswitch, itfBooleanUpdate
        VAR PUBLIC
            /// Defines whether the endswitch is normally open or closed.
            Behavior : EndswitchBehavior;

            /// Supervision time for action errors.
            SuperVisionTimeAction : LTIME := T#5s;

            /// Supervision time for reaction errors.
            SuperVisionTimeReaction : LTIME := T#1s;
        END_VAR
        
        VAR
            /// Binary signal for the endswitch.
            _binSignal : BinSignal;

            /// Timer for monitoring the endswitch.
            _monTimer : Ondelay;

            /// Current error state of the endswitch.
            _errorState : SuperVisionError;

            /// Current supervision mode of the endswitch.
            _superVisionMode : SuperVisionMode;

            /// Indicates if the endswitch is initialized.
            _isInitialized : BOOL;

            /// Indicates if the endswitch has been left.
            _hasLeft : BOOL;

            /// Indicates if the endswitch has been reached.
            _hasReached : BOOL;

            /// Alarm object for reporting errors.
            _Alarm : Alarm := (id := '4711', errorMessage := 'Endswitch fault');

            /// Counter for the number of errors detected.
            _count : INT;
        END_VAR

        /// Reads the cyclic signal and updates the internal state of the endswitch.
        /// Input: signal - Current signal state.
        ///        valid - Indicates if the signal is valid.
        ///        default - Default signal state.
        /// Returns: None.
        METHOD PUBLIC Update
            VAR_INPUT
                /// Current signal state.
                signal : BOOL;

                /// Indicates if the signal is valid.
                valid : BOOL := TRUE;

                /// Default signal state.
                default : BOOL := FALSE;
            END_VAR

            _binSignal.invert := Behavior = EndswitchBehavior#NormallyClosed;
            _binSignal.ReadCyclic(signal := signal, valid := valid, default := default);
            _hasLeft := _binSignal.QFal();
            _hasReached := _binSignal.QRis();
            _monTimer();
            _errorState := THIS.Check();
        END_METHOD

        /// Evaluates the current state of the endswitch and determines if a supervision error has occurred.
        /// Supervision errors include:
        /// - None: No error has occurred.
        /// - PositionError: The actuator's position changed unexpectedly.
        /// - ActionError: No action occurred after initiating a command, and the current position was not left.
        /// - ReactionError: The target position was not reached despite the command being executed.
        METHOD PRIVATE Check : SuperVisionError
            
            CASE _superVisionMode OF
                SuperVisionMode#None:
                    _monTimer(signal := FALSE);
                    Check := _errorState;
                SuperVisionMode#Reaction:
                    _monTimer(signal := TRUE, duration := SuperVisionTimeReaction);
                    Check := SuperVisionError#None;                    
                    IF (_hasReached) THEN
                        _monTimer(signal := FALSE);
                        Check := SuperVisionError#None;
                    END_IF;
                    // Error 
                    IF _monTimer.output THEN
                        _Alarm.errorMessage := 'Target position not reached (Reaction Error)';
                        THIS.Notify(e := _Alarm);
                        _count := _count + 1;
                        _monTimer(signal := FALSE);
                        Check := SuperVisionError#ReactionError;
                    END_IF;
                SuperVisionMode#Action:
                    _monTimer(signal := TRUE, duration := SuperVisionTimeAction);
                    IF (_hasLeft) THEN
                        _monTimer(signal := FALSE);
                        Check := SuperVisionError#None;
                    END_IF;

                    // Error 
                    IF _monTimer.output THEN
                        _Alarm.errorMessage := 'No action occurred after command initiation (Action Error)';
                        THIS.Notify(e := _Alarm);
                        _count := _count + 1;
                        _monTimer(signal := FALSE);
                        Check := SuperVisionError#ActionError;
                    END_IF;
                SuperVisionMode#PositionControl:
                    _monTimer(signal := FALSE);
                    Check := SuperVisionError#None;
                    IF _hasReached OR _hasLeft THEN
                        _Alarm.errorMessage := 'Unexpected position change detected (Position Error)';
                        THIS.Notify(e := _Alarm);
                        _count := _count + 1;
                        Check := SuperVisionError#PositionError;
                    END_IF;
            END_CASE;
            ;
        END_METHOD

        /// Returns the error status of the endswitch.
        /// Input: None.
        /// Returns: The current supervision error state of the endswitch.
        METHOD PUBLIC GetError : SuperVisionError
            GetError := _errorState;
        END_METHOD

        /// Starts monitoring the endswitch with a specified monitoring time.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                /// The supervision mode to enable.
                Mode : SuperVisionMode;
            END_VAR
            _superVisionMode := Mode;
            _monTimer(signal := FALSE);
        END_METHOD

        /// Checks if the monitoring time has elapsed.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := _monTimer.output;
        END_METHOD

        /// Checks if the endswitch is currently activated.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := _binSignal.Q();
            ;
        END_METHOD

        /// Checks if the endswitch has been reached.
        METHOD PUBLIC HasReached : BOOL
            HasReached := _binSignal.QRis();
            ;
        END_METHOD

        /// Checks if the endswitch has been left.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := _binSignal.QFal();
            ;
        END_METHOD
    END_CLASS

END_NAMESPACE
