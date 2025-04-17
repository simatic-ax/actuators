NAMESPACE Simatic.Ax.Actuators

    // Represents a 2-way actuator that can move between two positions: Home and Work.
    CLASS Actuator2Way
        EXTENDS ActuatorBase
        VAR PUBLIC
            // Public variables can be declared here if needed.
        END_VAR

        // Initializes the actuator. This method is called during the setup phase.
        METHOD PROTECTED OVERRIDE InitActuator
            ;
        END_METHOD

        // Executes the actuator logic based on its current state and sensor inputs.
        METHOD PROTECTED OVERRIDE ExecuteActuator
            VAR_TEMP
                _isInHomePos, _isInWorkPos : BOOL; // Flags for sensor states.
                _currentState : ActuatorState;    // Current state of the actuator.
            END_VAR

            // Ensure the output to work position is not null.
            IF (Q_ToWorkPosition = NULL) THEN
                THIS.SetError(WORD#16#8101); // Set error code for invalid configuration.
                RETURN;
            END_IF;

            // Read sensor states.
            _isInHomePos := I_InHomePosition.IsActivated();
            _currentState := THIS.GetState();
            _isInWorkPos := I_InWorkPosition.IsActivated();

            // Handle state transitions based on the current state.
            CASE _currentState OF
                //##############################################
                // Undefined: Determine the actuator's position.
                //##############################################
                ActuatorState#Undefined:
                    IF NOT (_isInHomePos) AND NOT (_isInWorkPos) THEN
                        THIS.ChangeState(ActuatorState#MoveToHomePosition);

                    ELSIF (_isInHomePos) AND NOT (_isInWorkPos) THEN
                        THIS.ChangeState(ActuatorState#InHomePosition);
                    ELSIF NOT (_isInHomePos) AND (_isInWorkPos) THEN
                        THIS.ChangeState(ActuatorState#InWorkPosition);
                    ELSE
                        ; // Error: Both sensors are activated.
                    END_IF;

                //##############################################
                // InHomePosition: Hold the home position.
                //##############################################
                ActuatorState#InHomePosition:
                    THIS.SetDone();
                    Q_ToHomePosition.Hold();

                //##############################################
                // Move to Work position: Transition to work position.
                //##############################################
                ActuatorState#MoveToWorkPosition:
                    IF THIS.StateHasChanged() THEN
                        Q_ToWorkPosition.Set();
                        Q_ToHomePosition.Reset();
                        I_InWorkPosition.StartMonitoring(TMonToWorkPosition);
                    END_IF;
                    IF (I_InWorkPosition.IsActivated()) THEN
                        THIS.SetDone();
                        Q_ToWorkPosition.Hold();
                        THIS.ChangeState(ActuatorState#InWorkPosition);
                    END_IF;

                //##############################################
                // InWorkPosition: Hold the work position.
                //##############################################
                ActuatorState#InWorkPosition:
                    THIS.SetDone();
                    Q_ToWorkPosition.Hold();

                //##############################################
                // Move to Home position: Transition to home position.
                //##############################################
                ActuatorState#MoveToHomePosition:
                    IF (THIS.StateHasChanged()) THEN
                        Q_ToHomePosition.Set();
                        Q_ToWorkPosition.Reset();
                        I_InHomePosition.StartMonitoring(TMonToHomePosition);
                    END_IF;
                    IF (I_InHomePosition.IsActivated()) THEN
                        THIS.ChangeState(ActuatorState#InHomePosition);
                        Q_ToHomePosition.Hold();
                        THIS.SetDone();
                    END_IF;

                //##############################################
                // Error: Handle error state.
                //##############################################
                ActuatorState#Error:
                    ;
            END_CASE;
        END_METHOD
    END_CLASS

END_NAMESPACE
