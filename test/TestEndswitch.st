USING AxUnit.Assert;
USING AxUnit.ResultFunctions;
USING System.Strings;
NAMESPACE Simatic.Ax.Actuators

    {TestFixture}
    CLASS TestEndswitch
        VAR
            _endswitch, _endswitchStateless  : BooleanEndswitch;
            res : BOOL;
        END_VAR

        {Setup}
        METHOD PUBLIC Setup
            _endswitch := _endswitchStateless;
        END_METHOD

        {Test}
        METHOD PUBLIC TestIsActivated
            VAR
                signal : BOOL := TRUE;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.Update(signal := TRUE, valid := valid);
            IsTrue(condition := _endswitch.IsActivated());
        END_METHOD

        {Test}
        METHOD PUBLIC TestHasReached
            VAR
                signal : BOOL := TRUE;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.Update(signal := FALSE, valid := valid);
            _endswitch.Update(signal := TRUE, valid := valid);
            IsTrue(condition := _endswitch.HasReached());
        END_METHOD

        {Test}
        METHOD PUBLIC TestHasLeft
            VAR
                signal : BOOL;
                valid : BOOL := TRUE;
            END_VAR

            _endswitch.Update(signal := TRUE, valid := valid);
            _endswitch.Update(signal := FALSE, valid := valid);
            IsTrue(condition := _endswitch.HasLeft());
        END_METHOD

        {Test}
        METHOD PUBLIC TestEnableSupervision
            VAR
                mode : SuperVisionMode;
            END_VAR

            // Test enabling supervision with different modes
            mode := SuperVisionMode#None;
            _endswitch.EnableSupervision(Mode := mode);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());

            mode := SuperVisionMode#Reaction;
            _endswitch.EnableSupervision(Mode := mode);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());

            mode := SuperVisionMode#Action;
            _endswitch.EnableSupervision(Mode := mode);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());

            mode := SuperVisionMode#PositionControl;
            _endswitch.EnableSupervision(Mode := mode);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());
        END_METHOD

        {Test}
        METHOD PUBLIC TestUpdateAndCheck
            VAR
                signal : BOOL;
                valid : BOOL := TRUE;
                default : BOOL := FALSE;
            END_VAR

            // Test updating the endswitch with valid signals
            signal := TRUE;
            _endswitch.Update(signal := signal, valid := valid, default := default);
            IsTrue(condition := _endswitch.IsActivated());

            signal := FALSE;
            _endswitch.Update(signal := signal, valid := valid, default := default);
            IsFalse(condition := _endswitch.IsActivated());

            // Test supervision errors
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Reaction);
            _endswitch.Update(signal := FALSE, valid := valid, default := default);
            _endswitch.Update(signal := TRUE, valid := valid, default := default);
            IsTrue(condition := _endswitch.HasReached());

            _endswitch.EnableSuperVision(Mode := SuperVisionMode#Action);
            _endswitch.Update(signal := TRUE, valid := valid, default := default);
            _endswitch.Update(signal := FALSE, valid := valid, default := default);
            IsTrue(condition := _endswitch.HasLeft());
        END_METHOD

        {Test}
        METHOD PUBLIC TestGetError
            VAR
                mode : SuperVisionMode;
            END_VAR

            // Test getting error states
            mode := SuperVisionMode#None;
            _endswitch.EnableSupervision(Mode := mode);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());

            mode := SuperVisionMode#Reaction;
            _endswitch.EnableSupervision(Mode := mode);
            _endswitch.Update(signal := FALSE);
            _endswitch.Update(signal := TRUE);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());

            mode := SuperVisionMode#Action;
            _endswitch.EnableSupervision(Mode := mode);
            _endswitch.Update(signal := TRUE);
            _endswitch.Update(signal := FALSE);
            EqualSuperVisionError(expected := SuperVisionState#None, actual := _endswitch.GetError());
        END_METHOD

        {Test}
        // Tests the error behavior for SuperVisionMode#Reaction.
        METHOD PUBLIC Test_ReactionError_Without_any_error
            // Step 1: Mock the OnDelay timer to simulate the timer not elapsed
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_false');
            
            // Step 2: Enable Reaction supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Reaction);

            // Step 3: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := FALSE);
            _endswitch.Update(signal := FALSE);

            // Step 4: Verify that the no error is returned.
            Equal(expected := SuperVisionState#EvaluatingRecaction, actual := _endswitch.GetError());

            // Step 5: Simulate the condition where the target position is reached.
            _endswitch.Update(signal := TRUE);
            
            // Step 6: Verify that the no error is returned.
            Equal(expected := SuperVisionState#None, actual := _endswitch.GetError());
        END_METHOD


        {Test}
        // Tests the error behavior for SuperVisionMode#Reaction.
        METHOD PUBLIC Test_ReactionError_With_error
            // Step 1: Mock the OnDelay timer to simulate the timer not elapsed
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_false');
            
            // Step 2: Enable Reaction supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Reaction);

            // Step 3: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := FALSE);

            // Step 4: Mock the OnDelay timer to simulate the timer elapsing.
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_true');

            // Step 5: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := FALSE);

            // Step 6: Verify that the ReactionError is returned.
            Equal(expected := SuperVisionState#ReactionError, actual := _endswitch.GetError());
        END_METHOD


        {Test}
        // Tests the error behavior for SuperVisionMode#Action.
        METHOD PUBLIC Test_ActionError_Without_any_error
            // Step 1: Mock the OnDelay timer to simulate the timer not elapsed
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_false');
            
            // Step 2: Enable Reaction supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Action);

            // Step 3: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := TRUE);
            _endswitch.Update(signal := TRUE);

            // Step 4: Verify that the no error is returned.
            Equal(expected := SuperVisionState#EvaluatingAction, actual := _endswitch.GetError());

            // Step 5: Simulate the condition where the target position is reached.
            _endswitch.Update(signal := FALSE);

            // Step 6: Verify that the no error is returned.
            Equal(expected := SuperVisionState#None, actual := _endswitch.GetError());
            
        END_METHOD


        {Test}
        // Tests the error behavior for SuperVisionMode#Action.
        METHOD PUBLIC Test_ActionError_With_error
            // Step 1: Mock the OnDelay timer to simulate the timer not elapsed
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_false');
            
            // Step 2: Enable Reaction supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Action);

            // Step 3: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := FALSE);

            // Step 4: Mock the OnDelay timer to simulate the timer elapsing.
            AxUnit.Mocking.Mock('System.Timer.OnDelay', 'Simatic.Ax.Mocks.OnDelayMock_true');

            // Step 5: Simulate the condition where the target position is not reached.
            _endswitch.Update(signal := FALSE);

            // Step 6: Verify that the ReactionError is returned.
            Equal(expected := SuperVisionState#ActionError, actual := _endswitch.GetError());
        END_METHOD


        {Test}
        // Tests the error behavior for SuperVisionMode#PositionControl.
        METHOD PUBLIC Test_Error_Behavior_PositionControl
            // Step 1: Enable PositionControl supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#PositionControl);

            // Step 2: Simulate an unexpected position change.
            _endswitch.Update(signal := TRUE);
            _endswitch.Update(signal := FALSE);

            // Step 3: Verify that the PositionError is returned.
            Equal(expected := SuperVisionState#PositionError, actual := _endswitch.GetError());
        END_METHOD

        {Test}
        // Tests the Evaluating state for SuperVisionMode#Reaction.
        METHOD PUBLIC Test_Evaluating_State_Reaction
            // Step 1: Enable Reaction supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Reaction);

            // Step 2: Simulate the condition where the target position is not yet reached.
            _endswitch.Update(signal := FALSE);

            // Step 3: Verify that the Evaluating state is returned.
            Equal(expected := SuperVisionState#EvaluatingRecaction, actual := _endswitch.GetError());
        END_METHOD

        {Test}
        // Tests the Evaluating state for SuperVisionMode#Action.
        METHOD PUBLIC Test_Evaluating_State_Action
            // Step 1: Enable Action supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#Action);

            // Step 2: Simulate the condition where no action has occurred yet.
            _endswitch.Update(signal := TRUE);

            // Step 3: Verify that the Evaluating state is returned.
            Equal(expected := SuperVisionState#EvaluatingAction, actual := _endswitch.GetError());
        END_METHOD

        {Test}
        // Tests the Evaluating state for SuperVisionMode#PositionControl.
        METHOD PUBLIC Test_Evaluating_State_PositionControl
            // Step 1: Enable PositionControl supervision mode.
            _endswitch.EnableSupervision(Mode := SuperVisionMode#PositionControl);

            // Step 2: Simulate the condition where no unexpected position change has occurred yet.
            _endswitch.Update(signal := TRUE);

            // Step 3: Verify that the Evaluating state is returned.
            Equal(expected := SuperVisionState#EvaluatingPosition, actual := _endswitch.GetError());
        END_METHOD
    END_CLASS


    FUNCTION EqualSuperVisionError
        VAR_INPUT
            expected : SuperVisionState;
            actual : SuperVisionState;
            messageOnFail : STRING;
            {CallerFilePath}
            file : WSTRING[1024];
            {CallerLineNumber}
            line : INT;
        END_VAR
        VAR_TEMP
            messageStr : STRING;
        END_VAR

        IF expected = actual THEN
            axunit_Succeed();
        ELSE
            messageStr := Concat('Expected = ', ToStringSuperVisionError(expected), ' Actual = ', ToStringSuperVisionError(actual));
            axunit_Fail(messageStr, file, line);
        END_IF;
    END_FUNCTION

    FUNCTION ToStringSuperVisionError : STRING
        VAR_INPUT
            val : SuperVisionState;
        END_VAR
        IF val = SuperVisionState#None THEN
            ToStringSuperVisionError := 'None';
        ELSIF val = SuperVisionState#PositionError THEN
            ToStringSuperVisionError := 'PositionControl';
        ELSIF val = SuperVisionState#ActionError THEN
            ToStringSuperVisionError := 'Action';
        ELSIF val = SuperVisionState#ReactionError THEN
            ToStringSuperVisionError := 'Reaction';
        ELSE
            ToStringSuperVisionError := 'Unknown';
        END_IF;
    END_FUNCTION

END_NAMESPACE
