USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    // Test class for the Actuator2Way class.
    // This class contains tests to verify the behavior of the Actuator2Way component.
    CLASS TestActuator3WayErrorHandling
        VAR
            // Instance of Actuator2Way for testing.
            _actuator, _actuatorStateless : Actuator3Way;

            // Command interface for actuator operations.
            _cmd : itfCommand;

            // State of the PLCOpen command.
            _plcOpenState : PlcOpen;

            // Mock sensors for testing actuator behavior.
            _sensorActivated : EndSwitchMockActivated;
            _sensorNotActivated : EndSwitchMockNotActivated;
            _sensorHasReached : EndSwitchMockHasReached;
            _sensorHasLeft : EndSwitchMockHasLeft;
            _sensorTimeHasElapsed : EndSwitchMockTimeHasElapsed;

            // Actuator Controls
            ActuatorMoveToHomePos : PositionControl;
            ActuatorMoveToWorkPos : PositionControl;
        END_VAR

        {TestSetup}
        // Sets up the test environment by initializing the actuator instance and assigning mock sensors and controls.
        METHOD PUBLIC Setup
            _actuator := _actuatorStateless;
            _actuator.Q_ToHomePosition := ActuatorMoveToHomePos;
            _actuator.Q_ToWorkPosition := ActuatorMoveToWorkPos;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InHomePosition := _sensorNotActivated;
        END_METHOD

        {Test}
        // Tests the transition to MoveToWorkPosition state when not in the work position.
        METHOD PUBLIC Command_MoveToWorkPosition_Error_When_Sensor_Time_Has_Elapsed
            VAR
                resultHome, resultWork : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);

            // Step 5: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorTimeHasElapsed;
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator has reached the work position.
            Equal(expected := PlcOpen#Error, actual := _plcOpenState);
            Equal(expected := ActuatorState#Error, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD


        {Test}
        // Tests the transition to MoveToHomePosition state when not in the home position.
        METHOD PUBLIC Reset_Actuator_Returns
            VAR
                resultHome, resultWork : BOOL;
            END_VAR
            THIS.Command_MoveToWorkPosition_Error_When_Sensor_Time_Has_Elapsed();
            // Step 1: Reset Actuator

            _actuator.Reset();

            // Step 2: Verify the actuator is in the MoveToHomePosition state.
            Equal(expected := ActuatorState#Undefined, actual := _actuator.GetState());

            // Step 3: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD

        {Test}
        // Tests the transition to MoveToWorkPosition state when not in the work position.
        METHOD PUBLIC Both_sensors_Active_Retrurs_Error
            VAR
                resultHome, resultWork : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorActivated;
            _actuator.I_InWorkPosition := _sensorActivated;

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition state.
            Equal(expected := PlcOpen#Error, actual := _plcOpenState);
            Equal(expected := ActuatorState#Error, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD
    END_CLASS

END_NAMESPACE
