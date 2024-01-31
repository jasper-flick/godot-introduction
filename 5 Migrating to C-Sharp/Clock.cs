using Godot;
using System;

using static Godot.GD;
using static Godot.Mathf;

namespace GodotIntroduction;

[GlobalClass]
public partial class Clock : RigidBody2D
{
	public enum StartTimeMode
	{
		SystemTime,
		RandomTime,
		FixedTime,
		OffsetTime,
	}

	[Export]
	public double TimeScale { get; set; } = 1.0;

	[Export]
	public StartTimeMode StartTime { get; set; }
	
	[ExportGroup("Fixed or Offset Start Time")]
	[Export(PropertyHint.Range, "-11,11")]
	public int StartHour { get; set; }

	[Export(PropertyHint.Range, "0,59")]
	public int StartMinute { get; set; }

	[Export(PropertyHint.Range, "0,59")]
	public int StartSecond { get; set; }

	[ExportGroup("Nodes"), Export]
	private CollisionShape2D _collisionShape;

	[Export]
	private Node2D _visualization;

	[ExportSubgroup("Arms"), Export]
	private Node2D _secondArm, _minuteArm, _hourArm;

	private double _seconds;

	private float _patternChoiceValue;

	public override void _Ready()
	{
		if (StartTime == StartTimeMode.RandomTime)
		{
			_seconds = RandRange(0.0, 43200.0);
		}
		else
		{
			if (StartTime != StartTimeMode.FixedTime)
			{
				_seconds = DateTime.Now.TimeOfDay.TotalSeconds;
			}
			if (StartTime != StartTimeMode.SystemTime)
			{
				_seconds = StartSecond + StartMinute * 60 + StartHour * 3600;
			}
		}
		_patternChoiceValue = Randf();
	}

	public override void _Process(double delta)
	{
		_seconds += delta * TimeScale;
		var s = (float)(_seconds % 60.0) / 60f;
		var m = (float)(_seconds / 60.0 % 60.0) / 60f;
		var h = (float)(_seconds / 3600.0 % 12.0) / 12f;
		_secondArm.Rotation = s * Tau;
		_minuteArm.Rotation = m * Tau;
		_hourArm.Rotation = h * Tau;
		_visualization.SelfModulate = new Color(s, m, h, _patternChoiceValue);
	}

	public void SetUniformScale(float scaleFactor)
	{
		var scaleVector = new Vector2(scaleFactor, scaleFactor);
		_collisionShape.Scale = scaleVector;
		_visualization.Scale = scaleVector;
		Mass = scaleFactor * scaleFactor;
	}
}
