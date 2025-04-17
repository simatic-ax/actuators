USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    // Test class for the Actuator3Way class.
    // This class contains tests to verify the behavior of the Actuator3Way component.
    CLASS TestActuator3Way
        VAR
            // Instance of Actuator3Way for testing.
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

            // Actuator Controls
            ActuatorMoveToHomePos : PositionControl;
            ActuatorMoveToWorkPos : PositionControl;
            ActuatorMoveToWorkPos2 : PositionControl;
        END_VAR

        {TestSetup}
        // Sets up the test environment by initializing the actuator instance and assigning mock sensors and controls.
        METHOD PUBLIC Setup
            _actuator := _actuatorStateless;
            _actuator.Q_ToHomePosition := ActuatorMoveToHomePos;
            _actuator.Q_ToWorkPosition := ActuatorMoveToWorkPos;
            _actuator.Q_ToWorkPosition2 := ActuatorMoveToWorkPos2;
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
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);
            IsFalse(condition := resultWork2);

            // Step 5: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator has reached the work position.
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        // Tests the transition to MoveToWorkPosition2 state when not in the second work position.
        METHOD PUBLIC Command_MoveToWorkPosition2_Returns_State_MoveToWorkPosition2_When_NotInWorkpos2
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Step 2: Issue the command to move to work position 2.
            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition2 state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsTrue(condition := resultWork2);

            // Step 5: Simulate reaching the second work position.
            _actuator.I_InWorkPosition2 := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator has reached the second work position.
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition2, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        // Tests the transition to MoveToHomePosition state when not in the home position.
        METHOD PUBLIC Command_MoveToHomePosition_Returns_State_MoveToHomePosition_When_NotInHomePos
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Step 2: Issue the command to move to home position.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToHomePosition state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);

            // Step 5: Simulate reaching the home position.
            _actuator.I_InHomePosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        METHOD PUBLIC Call_Command_MoveToWorkPosition2_Multiple
            VAR
                isInHomePos : BOOL := TRUE;
            END_VAR

            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;
            
            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            _actuator.I_InWorkPosition2 := _sensorActivated;
            _cmd := _actuator.GoToWorkPosition2();
            Equal(expected := ActuatorState#InWorkPosition2, actual := _actuator.GetState());
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition2, actual := _actuator.GetState());
        END_METHOD

        {Test}
        METHOD PUBLIC Command_MoveToWorkPosition_Interrupted_By_MoveToHomePosition
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Start MoveToWorkPosition
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);
            IsFalse(condition := resultWork2);

            // Interrupt with MoveToHomePosition
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);

            _actuator.I_InHomePosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs again.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        METHOD PUBLIC Command_MoveToHomePosition_Interrupted_By_MoveToWorkPosition
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Start MoveToHomePosition
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);

            // Interrupt with MoveToWorkPosition
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);
            IsFalse(condition := resultWork2);

            _actuator.I_InWorkPosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        METHOD PUBLIC Command_MoveToWorkPosition2_Interrupted_By_MoveToHomePosition
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is not in any position.
            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Step 2: Start MoveToWorkPosition2.
            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the actuator is in the MoveToWorkPosition2 state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            // Step 4: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsTrue(condition := resultWork2);

            // Step 5: Interrupt with MoveToHomePosition.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 6: Verify the actuator is in the MoveToHomePosition state.
            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToHomePosition, actual := _actuator.GetState());

            // Step 7: Check the actuator outputs.
            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsTrue(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);

            // Step 8: Simulate reaching the home position.
            _actuator.I_InHomePosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);

            // Step 9: Verify the actuator has reached the home position.
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InHomePosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD

        {Test}
        METHOD PUBLIC Command_MoveToWorkPosition2_Interrupted_By_MoveToWorkPosition
            VAR
                resultHome, resultWork, resultWork2 : BOOL;
            END_VAR

            _actuator.I_InHomePosition := _sensorNotActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _actuator.I_InWorkPosition2 := _sensorNotActivated;

            // Start MoveToWorkPosition2
            _cmd := _actuator.GoToWorkPosition2();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition2, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsTrue(condition := resultWork2);

            // Interrupt with MoveToWorkPosition
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            Equal(expected := PlcOpen#Busy, actual := _plcOpenState);
            Equal(expected := ActuatorState#MoveToWorkPosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsTrue(condition := resultWork);
            IsFalse(condition := resultWork2);

            _actuator.I_InWorkPosition := _sensorHasReached;
            _plcOpenState := Await(_cmd);
            Equal(expected := PlcOpen#Done, actual := _plcOpenState);
            Equal(expected := ActuatorState#InWorkPosition, actual := _actuator.GetState());

            ActuatorMoveToHomePos.WriteCyclic(Q => resultHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => resultWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => resultWork2);
            IsFalse(condition := resultHome);
            IsFalse(condition := resultWork);
            IsFalse(condition := resultWork2);
        END_METHOD
    END_CLASS

END_NAMESPACE
