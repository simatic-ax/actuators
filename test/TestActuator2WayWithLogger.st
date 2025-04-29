USING AxUnit.Assert;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    // Test class for the Actuator2Way class.
    // This class contains tests to verify the behavior of the Actuator2Way component.
    CLASS TestActuator2WayWithLogger
        VAR
            // Instance of Actuator2Way for testing.
            _actuator, _actuatorStateless : Actuator2Way;
            
            // Command interface for actuator operations.
            _cmd : itfCommand;

            // Logger
            _logger : StateLogger;
            _msgBuffer : ARRAY[1..1] OF LogMessage;

            // State of the PLCOpen command.
            _plcOpenState : PlcOpen;

            // Mock sensors for testing actuator behavior.
            _sensorActivated : EndSwitchMockActivated;
            _sensorNotActivated : EndSwitchMockNotActivated;
            _sensorHasReached : EndSwitchMockHasReached;
            _sensorHasLeft : EndSwitchMockHasLeft;

        END_VAR

        {TestSetup}
        // Sets up the test environment by initializing the actuator instance and assigning mock sensors and controls.
        METHOD PUBLIC Setup
            _actuator := _actuatorStateless;
            _actuator.Logger := _logger;
            _logger.MsgBuffer := REF(_msgBuffer);
            _logger.SetLogLevel(LogLevel#Info);
        END_METHOD


        {Test}
        // Tests the state transitions and verifies log entries in the StateLogger.
        METHOD PUBLIC Test_a_CompleteSequence_to_check_the_LogMessages
            VAR
                logEntry : STRING;
            END_VAR

            // Step 1: Set initial sensor states to indicate the actuator is in the home position.
            _actuator.I_InHomePosition := _sensorActivated;
            _actuator.I_InWorkPosition := _sensorNotActivated;

            // Step 2: Issue the command to move to work position.
            _cmd := _actuator.GoToWorkPosition();
            _plcOpenState := Await(_cmd);

            // Step 3: Verify the log entry for State changed to MoveToWorkPosition.
            logEntry := _logger.MsgBuffer^[1].message;
            Equal(expected := 'State changed to MoveToWorkPosition', actual := logEntry);

            // Step 4: Simulate reaching the work position.
            _actuator.I_InWorkPosition := _sensorHasReached;
            _actuator.I_InHomePosition := _sensorNotActivated;
            _plcOpenState := Await(_cmd);

            // Step 5: Verify the log entry for reaching InWorkPosition.
            logEntry := _logger.MsgBuffer^[1].message;
            Equal(expected := 'State changed to InWorkPosition', actual := logEntry);

            // Step 6: Issue the command to move to home position.
            _cmd := _actuator.GoToHomePosition();
            _plcOpenState := Await(_cmd);

            // Step 7: Verify the log entry for State changed to MoveToHomePosition.
            logEntry := _logger.MsgBuffer^[1].message;
            Equal(expected := 'State changed to MoveToHomePosition', actual := logEntry);

            // Step 8: Simulate reaching the home position.
            _actuator.I_InHomePosition := _sensorHasReached;
            _actuator.I_InWorkPosition := _sensorNotActivated;
            _plcOpenState := Await(_cmd);

            // Step 9: Verify the log entry for reaching InHomePosition.
            logEntry := _logger.MsgBuffer^[1].message;
            Equal(expected := 'State changed to InHomePosition', actual := logEntry);
        END_METHOD

    END_CLASS

END_NAMESPACE
