USING Simatic.Ax.Commands;
USING Simatic.Ax.AutomationFramework;

NAMESPACE Simatic.Ax.Actuators

    // Abstract base class for actuators, providing common functionality for actuator control.
    CLASS ABSTRACT ActuatorBase
        EXTENDS ExecuteControlModuleAbstract
        IMPLEMENTS itfActuator

        // Public variables
        VAR PUBLIC
            I_InHomePosition : itfEndswitch; // End switch indicating the actuator is in the home position.
            I_InWorkPosition : itfEndswitch; // End switch indicating the actuator is in the work position.
            Q_ToHomePosition : itfPositionControl;  // Command to move the actuator to the home position.
            Q_ToWorkPosition : itfPositionControl;  // Command to move the actuator to the work position.
            TMonToWorkPosition : LTIME := T#5s; // Monitoring time for moving to the work position. Default: 5 seconds.
            TMonToHomePosition : LTIME := T#5s; // Monitoring time for moving to the home position. Default: 5 seconds.
        END_VAR

        // Private variables
        VAR PRIVATE
            _stateOld : ActuatorState;
            _currentState : ActuatorState;
            _stateHasChanged : BOOL;
            _simFeedbackHomePos : BOOL;
            _simFeedbackWorkPos : BOOL;
            _hasActiveToHome : BOOL := TRUE;
            _hasActiveToWork : BOOL := TRUE;
            _binSignalWorkPosNull : NullEndswitch;
            _binSignalHomePosNull : NullEndswitch;
            _outSignalWhenNull : NullPositionControl;
        END_VAR

        // Executes type-specific logic for the actuator.
        METHOD PROTECTED OVERRIDE _executeTypeSpecific
            _stateHasChanged := _currentState <> _stateOld;
            _stateOld := _currentState;
            IF (_simFeedbackHomePos) THEN
                _binSignalHomePosNull.ReadCyclic();
                ;
            END_IF;
            IF (_simFeedbackWorkPos) THEN
                _binSignalWorkPosNull.ReadCyclic();
                ;
            END_IF;
            THIS.ExecuteActuator();
        END_METHOD

        // Initializes the actuator's configuration.
        METHOD PROTECTED OVERRIDE _initmethod
            IF (I_InHomePosition = NULL) THEN
                I_InHomePosition := _binSignalHomePosNull;
                _simFeedbackHomePos := TRUE;
            END_IF;
            IF (I_InWorkPosition = NULL) THEN
                I_InWorkPosition := _binSignalWorkPosNull;
                _simFeedbackWorkPos := TRUE;
            END_IF;
            IF (Q_ToWorkPosition = NULL) THEN
                Q_ToWorkPosition := _outSignalWhenNull;
                _hasActiveToWork := FALSE;
            END_IF;
            IF (Q_ToHomePosition = NULL) THEN
                Q_ToHomePosition := _outSignalWhenNull;
                _hasActiveToHome := FALSE;
            END_IF;
            THIS.InitActuator();
            ;
        END_METHOD

        // Executes actuator-specific logic. This method must be implemented by derived classes.
        METHOD PROTECTED ABSTRACT ExecuteActuator
        END_METHOD

        // Initializes the actuator. This method must be implemented by derived classes.
        METHOD PROTECTED ABSTRACT InitActuator
        END_METHOD

        // Retrieves the current state of the actuator.
        METHOD PUBLIC GetState : ActuatorState
            GetState := _currentState;
        END_METHOD

        // Command to move the actuator to the home position.
        METHOD PUBLIC GoToHomePosition : itfCommand
            THIS.InitState();
            IF (I_InHomePosition = NULL) THEN
                THIS._initmethod();
            END_IF;
            IF (I_InHomePosition.HasReached()) THEN
                _currentState := ActuatorState#InHomePosition;
            ELSE
                _currentState := ActuatorState#MoveToHomePosition;
            END_IF;
            GoToHomePosition := THIS;
            ;
        END_METHOD

        // Command to move the actuator to the first work position.
        METHOD PUBLIC GoToWorkPosition : itfCommand
            THIS.InitState();
            IF (I_InWorkPosition = NULL) THEN
                THIS._initmethod();
            END_IF;
            IF (I_InWorkPosition.IsActivated()) THEN
                _currentState := ActuatorState#InWorkPosition;
            ELSE
                _currentState := ActuatorState#MoveToWorkPosition;
            END_IF;
            GoToWorkPosition := THIS;
        END_METHOD

        // Command to move the actuator to the second work position.
        METHOD PUBLIC GoToWorkPosition2 : itfCommand
            THIS.SetDone();
            GoToWorkPosition2 := NULL;
        END_METHOD

        // Checks if the actuator's state has changed.
        METHOD PROTECTED StateHasChanged : BOOL
            StateHasChanged := _stateHasChanged;
        END_METHOD

        // Changes the current state of the actuator.
        METHOD PROTECTED ChangeState
            VAR_INPUT
                NewState : ActuatorState; // The new state to set for the actuator.
            END_VAR
            _currentState := NewState;
        END_METHOD
    END_CLASS

END_NAMESPACE
