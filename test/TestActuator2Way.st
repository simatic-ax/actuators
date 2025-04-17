USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    // Test class for the Actuator2Way class.
    // This class contains tests to verify the behavior of the Actuator2Way component.
    CLASS TestActuator2Way
        VAR
            // Instance of Actuator2Way for testing.
            _actuator, _actuatorStateless : Actuator2Way;

            // Command interface for actuator operations.
            _cmd : itfCommand;

            // State of the PLCOpen command.
            _plcOpenState : PlcOpen;

            // Mock sensors for testing actuator behavior.
            _sensorActivated : EndSwitchMockActivated;
            _sensorNotActivated : EndSwitchMockNotActivated;
            _sensorHasReached : EndSwitchMockHasReached;
            _sensorHasLeft : EndSwitchMockHasLeft;

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
        END_METHOD

        {Test}
        // Verifies that the initial state of the actuator is Undefined.
        METHOD PUBLIC TestInitialState
            VAR
                initialState : ActuatorState;
            END_VAR

            // Step 1: Retrieve the initial state of the actuator.
            initialState := _actuator.GetState();

            // Step 2: Assert that the initial state is Undefined.
            Equal(expected := ActuatorState#Undefined, actual := initialState);
        END_METHOD

        {Test}
        // Tests the transition to MoveToWorkPosition state when not in the work position.
        METHOD PUBLIC Command_MoveToWorkPosition_Returns_State_MoveToWorkPosition_When_NotInWorkpos
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
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);

            // Step 5: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator has reached the work position.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD

        {Test}
        // Tests that the actuator remains in InWorkPosition state when already in the work position.
        METHOD PUBLIC Command_MoveToWorkPosition_Returns_State_InWorkPosition_When_InWorkpos
            VAR
                isInWorkPos : BOOL := TRUE;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is already in the work position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorActivated;

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator remains in the InWorkPosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());
        END_METHOD

        {Test}
        // Tests the transition to MoveToHomePosition state when not in the home position.
        METHOD PUBLIC Command_MoveToHomePosition_Returns_State_MoveToHomePosition_When_NotIn_HomePos
            VAR
                resultHome, resultWork : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Issue the command to move to home position.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToHomePosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);

            // Step 5: Simulate reaching the home position.
            _actuator.I_InHomePosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator has reached the home position.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD

        {Test}
        // Tests that the actuator remains in InHomePosition state when already in the home position.
        METHOD PUBLIC Command_MoveToHomePosition_Returns_State_InHomePosition_When_In_HomePos
            VAR
                isInHomePos : BOOL := TRUE;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is already in the home position.
            _actuator.I_InHomePosition := _sensorActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Issue the command to move to home position.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator remains in the InHomePosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());
        END_METHOD
        
        {Test}
        // Tests multiple calls to the MoveToWorkPosition command.
        METHOD PUBLIC Call_Command_MoveToWorkPosition_Multiple
            VAR
                isInHomePos : BOOL := TRUE;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Issue the command to move to work position multiple times.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 3: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorActivated;
            _cmd := _actuator.GoToWorkPosition();
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());
            _plcOpenState := Await(_cmd);
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());
        END_METHOD

        {Test}
        // Tests the behavior when MoveToWorkPosition is interrupted by MoveToHomePosition.
        METHOD PUBLIC Command_MoveToWorkPosition_Interrupted_By_MoveToHomePosition
            VAR
                resultHome, resultWork : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Start MoveToWorkPosition.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);

            // Step 5: Interrupt with MoveToHomePosition.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator is in the MoveToHomePosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);

            // Step 8: Simulate reaching the home position.
            _actuator.I_InHomePosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 9: Verify the actuator has reached the home position.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());

            // Step 10: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD

        {Test}
        // Tests the behavior when MoveToHomePosition is interrupted by MoveToWorkPosition.
        METHOD PUBLIC Command_MoveToHomePosition_Interrupted_By_MoveToWorkPosition
            VAR
                resultHome, resultWork : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Start MoveToHomePosition.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToHomePosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);

            // Step 5: Interrupt with MoveToWorkPosition.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator is in the MoveToWorkPosition state.
            AxUnit.Assert.Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);

            // Step 8: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 9: Verify the actuator has reached the work position.
            AxUnit.Assert.Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());

            // Step 10: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
        END_METHOD
    END_CLASS

END_NAMESPACE
