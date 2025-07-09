USING Simatic.Ax.Commands;
USING System.Timer;
USING Simatic.Ax.AutomationFramework;

NAMESPACE Simatic.Ax.Actuators
    CLASS TimeBasedActuator
        EXTENDS ActuatorBase
        VAR PUBLIC
            OnDuration : TIME;
        END_VAR
        VAR
            _tonOffDuration : OffDelay;
        END_VAR

        METHOD PROTECTED OVERRIDE InitActuator
            ;
        END_METHOD

        METHOD PROTECTED OVERRIDE ExecuteActuator
            VAR_TEMP
                _currentState : ActuatorState;
            END_VAR
            
            IF (Q_ToWorkPosition = NULL) THEN 
                THIS.SetError(WORD#16#8101);
                RETURN;
            END_IF;
            _currentState := THIS.GetState();
            CASE _currentState OF
                // If undefined, go initial state:
                ActuatorState#Undefined:
                    THIS.ChangeState(ActuatorState#InHomePosition);
                // Switch all outputs off, when actuator is idle in home position
                ActuatorState#InHomePosition:
                    Q_ToWorkPosition.Reset();
                // Received the command GoToWorkPosition switch on ToWorkPosition
                ActuatorState#MoveToWorkPosition:
                    Q_ToWorkPosition.Set();
                    THIS.ChangeState(ActuatorState#InWorkPosition);
                // After Timeout switch off "ToWorkPosition"
                ActuatorState#InWorkPosition:
                    _tonOffDuration(signal := TRUE, Duration := OnDuration);
                    IF (_tonOffDuration.output) THEN
                        _tonOffDuration(signal := FALSE);
                        THIS.ChangeState(ActuatorState#MoveToHomePosition);
                        Q_ToWorkPosition.Reset();
                    END_IF;
                // Send done
                ActuatorState#MoveToHomePosition:
                    Q_ToWorkPosition.Reset();
                    THIS.ChangeState(ActuatorState#InHomePosition);
                    THIS.SetDone();
            END_CASE;
        END_METHOD

    
        METHOD PUBLIC OVERRIDE OnNotification
            VAR_INPUT
                i : Info;
            END_VAR
            ;
        END_METHOD
    END_CLASS

END_NAMESPACE
