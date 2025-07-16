USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    /// Test class for the 3-way actuator transitions.
    /// Input: None.
    /// Returns: None.
    {TestFixture}
    // Test class for the 3-way actuator transitions.
    CLASS TestActuator3WayTransitions
        VAR
            // Instance of Actuator3Way for testing.
            _actuator, _actuatorStateless : Actuator3Way;

            // Stateless instance of Actuator3Way for reinitialization.
            

            // Mock sensors for testing actuator behavior.
            SensorInHomePosition, _sensorInHomePositionStateless : BooleanEndswitch;
            SensorInWorkPosition, _sensorInWorkPositionStateless : BooleanEndswitch;
            SensorInWorkPosition2, _sensorInWorkPosition2Stateless : BooleanEndswitch;

            // Actuator Controls
            ActuatorMoveToHomePos, _actuatorMoveToHomePosStateless : PositionControl;
            ActuatorMoveToWorkPos, _actuatorMoveToWorkPosStateless : PositionControl;
            ActuatorMoveToWorkPos2, _actuatorMoveToWorkPos2Stateless : PositionControl;


            // Command interface for actuator operations.
            _cmd : itfCommand;
            _plcOpenState : PlcOpen;

        END_VAR
        /// Sets up the test environment for each test.
        /// Input: None.
        /// Returns: None.
        {TestSetup}
        // Sets up the test environment.
        METHOD PUBLIC Setup
            // Reinitialize the actuator instance with a stateless instance.
            _actuator := _actuatorStateless;

            // Assign stateless instances to sensors
            SensorInHomePosition := _sensorInHomePositionStateless;
            SensorInWorkPosition := _sensorInWorkPositionStateless;
            SensorInWorkPosition2 := _sensorInWorkPosition2Stateless;

            // Reinitialize actuator controls
            ActuatorMoveToHomePos := _actuatorMoveToHomePosStateless;
            ActuatorMoveToWorkPos := _actuatorMoveToWorkPosStateless;
            ActuatorMoveToWorkPos2 := _actuatorMoveToWorkPos2Stateless;

            _actuator.Q_ToHomePosition := ActuatorMoveToHomePos;
            _actuator.Q_ToWorkPosition := ActuatorMoveToWorkPos;
            _actuator.Q_ToWorkPosition2 := ActuatorMoveToWorkPos2;

            // Configure end switches
            _actuator.I_InHomePosition := SensorInHomePosition;
            _actuator.I_InWorkPosition := SensorInWorkPosition;
        END_METHOD

        {Test}
        /// Verifies the sequence of end switch states during the MoveToWorkPosition command.
        /// Input: None.
        /// Returns: None.
        METHOD PUBLIC TestMoveToWorkPosition_EndSwitchGoesToZero
            VAR
                q_ToHome, q_ToWork, q_ToWork2 : BOOL;
            END_VAR

            // Step 1: Set initial sensor states.
            SensorInHomePosition.Update(signal := TRUE); // HomePosition starts as true.
            SensorInWorkPosition.Update(signal := FALSE);
            SensorInWorkPosition2.Update(signal := FALSE);

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify HomePosition becomes false when the actuator starts.
            SensorInHomePosition.Update(signal := FALSE);
            _plcOpenState := Await(_cmd);

            ActuatorMoveToHomePos.WriteCyclic(Q => q_ToHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => q_ToWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => q_ToWork2);

            IsFalse(condition := q_ToHome); // HomePosition is now false.
            IsTrue(condition := q_ToWork);
            IsFalse(condition := q_ToWork2);



            // Step 4: Simulate reaching the work position and verify WorkPosition becomes true.
            SensorInWorkPosition.Update(signal := TRUE);
            _plcOpenState := Await(_cmd);

            ActuatorMoveToHomePos.WriteCyclic(Q => q_ToHome);
            ActuatorMoveToWorkPos.WriteCyclic(Q => q_ToWork);
            ActuatorMoveToWorkPos2.WriteCyclic(Q => q_ToWork2);

            IsFalse(condition := q_ToHome);
            IsFalse(condition := q_ToWork); // WorkPosition is now true.
            IsFalse(condition := q_ToWork2);
        END_METHOD
    END_CLASS

END_NAMESPACE
