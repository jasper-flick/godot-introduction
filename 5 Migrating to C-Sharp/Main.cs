using Godot;

using static Godot.GD;

namespace GodotIntroduction;

public partial class Main : Node2D
{
	[Export]
	private PackedScene _clockSceneCSharp, _clockSceneGDScript;

	[Export]
	private float _clockRadius = 128f;

	[ExportGroup("Clock Instances")]
	[Export(PropertyHint.Range, "0.1,1.0")]
	private float _scaleMin = 0.25f, _scaleMax = 1f;

	[Export]
	private float _timeScaleMin = -10f, _timeScaleMax = 10f;

	[ExportGroup("Nodes"), Export]
	private Node2D _bottom, _ground;

	private float _windowWidth;

	public override void _Ready()
	{
		GetWindow().SizeChanged += OnSizeChanged;
		OnSizeChanged();
	}
	
	private void OnSizeChanged()
	{
		Vector2I windowSize = GetWindow().Size;
		_windowWidth = windowSize.X;
		_bottom.Position = new Vector2(
			_bottom.Position.X, windowSize.Y + 2f * _clockRadius);
		_ground.Position = new Vector2(
			0.5f * windowSize.X, windowSize.Y + 0.5f * _clockRadius);
		_ground.Scale = new Vector2(windowSize.X, _clockRadius);
	}

	private Node2D SpawnClockCSharp()
	{
		var clock = _clockSceneCSharp.Instantiate<Clock>();
		clock.StartTime = Clock.StartTimeMode.RandomTime;
		clock.TimeScale = RandRange(_timeScaleMin, _timeScaleMax);
		clock.SetUniformScale((float)RandRange(_scaleMin, _scaleMax));
		return clock;
	}

	private Node2D SpawnClockGDScript()
	{
		var clock = _clockSceneGDScript.Instantiate<Node2D>();
		clock.Set("start_time", (int)Clock.StartTimeMode.RandomTime);
		clock.Set("time_scale", RandRange(_timeScaleMin, _timeScaleMax));
		clock.Call("set_uniform_scale", RandRange(_scaleMin, _scaleMax));
		return clock;
	}

	private void OnSpawnTimerTimeout()
	{
		Node2D clock;
		if (Randf() < 0.5f)
		{
			clock = SpawnClockCSharp();
		}
		else
		{
			clock = SpawnClockGDScript();
		}
		clock.Position = new Vector2(
			(float)RandRange(_clockRadius, _windowWidth - _clockRadius),
			-3f * _clockRadius);
		AddChild(clock);
	}

	private static void OnBottomBodyEntered(Node2D body) => body.QueueFree();
}
