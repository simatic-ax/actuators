USING AxUnit.Assert;
USING Simatic.Ax.Actuators;

NAMESPACE Simatic.Ax.Actuators.Tests

    /// Test fixture for PositionControl class functionality.
    {TestFixture}
    CLASS TestPositionControl
        VAR
            /// Instance of PositionControl for testing.
            _positionControl, _positionControlStateless : PositionControl;
            
            /// Result variables for testing.
            _result : BOOL;
            _output : BOOL;
        END_VAR

        {TestSetup}
        METHOD PUBLIC TestSetup
            _positionControl := _positionControlStateless;
        END_METHOD

        /// Test that Set method activates the position control.
        {Test}
        METHOD PUBLIC Test_Set_ActivatesPosition
            // Arrange
            _positionControl.Behavior := PositionBehavior#SelfHold;
            
            // Act
            _result := _positionControl.Set();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
        END_METHOD

        /// Test that Reset method deactivates the position control.
        {Test}
        METHOD PUBLIC Test_Reset_DeactivatesPosition
            // Arrange
            _positionControl.Set(); // First set it to true
            
            // Act
            _result := _positionControl.Reset();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
        END_METHOD

        /// Test that Hold method with ActiveHold behavior keeps position active.
        {Test}
        METHOD PUBLIC Test_Hold_ActiveHold_KeepsPositionActive
            // Arrange
            _positionControl.Behavior := PositionBehavior#ActiveHold;
            
            // Act
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
        END_METHOD

        /// Test that Hold method with SelfHold behavior deactivates position.
        {Test}
        METHOD PUBLIC Test_Hold_SelfHold_DeactivatesPosition
            // Arrange
            _positionControl.Behavior := PositionBehavior#SelfHold;
            _positionControl.Set(); // First set it to true
            
            // Act
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
        END_METHOD

        /// Test sequence: Set -> Hold (ActiveHold) -> Reset.
        {Test}
        METHOD PUBLIC Test_Sequence_Set_HoldActiveHold_Reset
            // Arrange
            _positionControl.Behavior := PositionBehavior#ActiveHold;
            
            // Act & Assert - Set
            _result := _positionControl.Set();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
            
            // Act & Assert - Hold
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
            
            // Act & Assert - Reset
            _result := _positionControl.Reset();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
        END_METHOD

        /// Test sequence: Set -> Hold (SelfHold) -> Set.
        {Test}
        METHOD PUBLIC Test_Sequence_Set_HoldSelfHold_Set
            // Arrange
            _positionControl.Behavior := PositionBehavior#SelfHold;
            
            // Act & Assert - Set
            _result := _positionControl.Set();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
            
            // Act & Assert - Hold (should deactivate)
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
            
            // Act & Assert - Set again
            _result := _positionControl.Set();
            _positionControl.WriteCyclic(Q => _output);
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
        END_METHOD

        /// Test default behavior is SelfHold.
        {Test}
        METHOD PUBLIC Test_DefaultBehavior_IsSelfHold
            // Arrange & Act
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
        END_METHOD

        /// Test changing behavior affects Hold method.
        {Test}
        METHOD PUBLIC Test_ChangingBehavior_AffectsHoldMethod
            // Arrange & Act - SelfHold
            _positionControl.Behavior := PositionBehavior#SelfHold;
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert - SelfHold
            Equal(expected := FALSE, actual := _result);
            Equal(expected := FALSE, actual := _output);
            
            // Arrange & Act - ActiveHold
            _positionControl.Behavior := PositionBehavior#ActiveHold;
            _result := _positionControl.Hold();
            _positionControl.WriteCyclic(Q => _output);
            
            // Assert - ActiveHold
            Equal(expected := TRUE, actual := _result);
            Equal(expected := TRUE, actual := _output);
        END_METHOD
    END_CLASS

    /// Test fixture for NullPositionControl class functionality.
    {TestFixture}
    CLASS TestNullPositionControl
        VAR
            /// Instance of NullPositionControl for testing.
            _nullPositionControl : NullPositionControl;
            
            /// Result variable for testing.
            _result : BOOL;
        END_VAR

        /// Test that Set method returns default value.
        {Test}
        METHOD PUBLIC Test_Set_ReturnsDefaultValue
            // Act
            _result := _nullPositionControl.Set();
            
            // Assert
            Equal(expected := FALSE, actual := _result);
        END_METHOD

        /// Test that Reset method returns default value.
        {Test}
        METHOD PUBLIC Test_Reset_ReturnsDefaultValue
            // Act
            _result := _nullPositionControl.Reset();
            
            // Assert
            Equal(expected := FALSE, actual := _result);
        END_METHOD

        /// Test that Hold method returns default value.
        {Test}
        METHOD PUBLIC Test_Hold_ReturnsDefaultValue
            // Act
            _result := _nullPositionControl.Hold();
            
            // Assert
            Equal(expected := FALSE, actual := _result);
        END_METHOD
    END_CLASS

END_NAMESPACE
