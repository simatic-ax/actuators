USING Simatic.Ax.Commands;
USING System.Timer;

NAMESPACE Simatic.Ax.Actuators

    CLASS Actuator3Way
        EXTENDS ActuatorBase
        VAR PUBLIC
            I_InWorkPosition2 : itfEndswitch;
            Q_ToWorkPosition2 : itfPositionControl;
        END_VAR
        VAR PROTECTED
            _MonitoringTimer : System.Timer.OnDelay;
            _simFeedbackWorkPos2, _hasActiveToWork2 : BOOL;
            _ActualPosition : INT;
            _binSignalWorkPos2Null : NullEndswitch;
            _outSignalWhenNull : NullPositionControl;
        END_VAR

        METHOD PROTECTED OVERRIDE InitActuator
            IF (I_InWorkPosition2 = NULL) THEN
                I_InWorkPosition2 := _binSignalWorkPos2Null;
                _simFeedbackWorkPos2 := TRUE;
            END_IF;
            IF (Q_ToWorkPosition2 = NULL) THEN
                Q_ToWorkPosition2 := _outSignalWhenNull;
                _hasActiveToWork2 := FALSE;
            END_IF;
        END_METHOD

        METHOD PROTECTED OVERRIDE ExecuteActuator
            VAR_TEMP
                _isInHomePos, _isInWorkPos, _isInWorkPos2 : BOOL;
                _currentState : ActuatorState;
            END_VAR
            IF (Q_ToWorkPosition = NULL) THEN
                THIS.SetError(WORD#16#8101);
                RETURN;
            END_IF;
            _isInHomePos := I_InHomePosition.IsActivated();
            _isInWorkPos := I_InWorkPosition.IsActivated();
            _isInWorkPos2 := I_InWorkPosition2.IsActivated();
            _currentState := THIS.GetState();
            CASE _currentState OF
                //##############################################
                // Undefined
                //##############################################
                ActuatorState#Undefined:
                    // actuator is in between the two sensors (Home- and WorkPos)
                    IF NOT (_isInHomePos) AND NOT (_isInWorkPos) AND NOT (_isInWorkPos2) THEN
                        THIS.ChangeState(ActuatorState#MoveToHomePosition);
                    // actuator is in HomePos
                    ELSIF (_isInHomePos) AND NOT (_isInWorkPos) AND NOT (_isInWorkPos2) THEN
                        THIS.ChangeState(ActuatorState#InHomePosition);
                    // actuator is in any Workpos
                    ELSIF NOT (_isInHomePos) AND (_isInWorkPos OR _isInWorkPos2) THEN
                        THIS.ChangeState(ActuatorState#InWorkPosition);
                    // both sensors are activated --> undefined state
                    ELSE
                        ; // Error
                    END_IF;
                //##############################################
                // InHomePosition
                //##############################################
                ActuatorState#InHomePosition:
                    Q_ToHomePosition.Hold();
                    THIS.SetDone();
                // Received the command GoToWorkPosition switch on ToWorkPosition
                //##############################################
                // MoveToWorkPosition
                //##############################################
                ActuatorState#MoveToWorkPosition:
                    IF (THIS.StateHasChanged()) THEN
                        Q_ToHomePosition.Reset();
                        Q_ToWorkPosition.Set();
                        Q_ToWorkPosition2.Reset();
                        I_InWorkPosition.StartMonitoring();
                    END_IF;
                    IF (I_InWorkPosition.IsActivated()) THEN
                        Q_ToWorkPosition.Hold();
                        THIS.SetDone();
                        THIS.ChangeState(ActuatorState#InWorkPosition);
                    END_IF;

                //##############################################
                // InWorkPosition
                //##############################################
                // ### Actuator is in Workposition 1
                ActuatorState#InWorkPosition:
                    Q_ToWorkPosition.Hold();    
                    THIS.SetDone();
                //##############################################
                // MoveToWorkPosition
                //##############################################
                ActuatorState#MoveToWorkPosition2:
                    IF (THIS.StateHasChanged()) THEN
                        Q_ToHomePosition.Reset();
                        Q_ToWorkPosition.Reset();
                        Q_ToWorkPosition2.Set();
                        I_InWorkPosition2.StartMonitoring();
                    END_IF;   
                    IF (I_InWorkPosition2.IsActivated()) THEN
                        Q_ToWorkPosition2.Hold();
                        THIS.SetDone();
                        THIS.ChangeState(ActuatorState#InWorkPosition2);
                    END_IF;                 
                //##############################################
                // InWorkPosition2
                //##############################################
                // ### Actuator is in Workposition 2 
                ActuatorState#InWorkPosition2:
                    Q_ToWorkPosition2.Hold();
                    THIS.SetDone();
                //##############################################
                // Move to home position
                //##############################################
                ActuatorState#MoveToHomePosition:
                    IF (THIS.StateHasChanged()) THEN
                        Q_ToHomePosition.Set();
                        Q_ToWorkPosition.Reset();
                        Q_ToWorkPosition2.Reset();
                        I_InHomePosition.StartMonitoring();
                    END_IF;
                    IF (I_InHomePosition.IsActivated()) THEN
                        Q_ToHomePosition.Hold();
                        THIS.SetDone();
                        THIS.ChangeState(ActuatorState#InHomePosition);
                    END_IF;
                ActuatorState#Error:
                    ;
            END_CASE;
        END_METHOD

        METHOD PUBLIC OVERRIDE GoToWorkPosition2 : itfCommand
            THIS.InitState();
            IF (I_InWorkPosition2 = NULL) THEN
                THIS.InitActuator();
            END_IF;
            IF (I_InWorkPosition2.IsActivated()) THEN
                THIS.ChangeState(ActuatorState#InWorkPosition2);
            ELSE
                THIS.ChangeState(ActuatorState#MoveToWorkPosition2);
            END_IF;
            GoToWorkPosition2 := THIS;
        END_METHOD
    END_CLASS

END_NAMESPACE
