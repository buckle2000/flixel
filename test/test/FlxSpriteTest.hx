package;

import massive.munit.util.Timer;
import flixel.FlxG;
import flixel.util.FlxArrayUtil;
import flixel.FlxSprite;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class FlxSpriteTest 
{
	public function new() {}

	public var sprite1:FlxSprite;
	public var sprite2:FlxSprite;
	
	@BeforeClass
	public function setup():Void {
		sprite1 = new FlxSprite();
		sprite1.makeGraphic(100,100);

		sprite2 = new FlxSprite();
		sprite2.makeGraphic(100,100);
	}
	
	@Test
	public function sprites():Void 
	{
		Assert.isNotNull(sprite1);
		Assert.isNotNull(sprite2);
		
		Assert.isNotNull(sprite1.active);
		Assert.isNotNull(sprite2.active);
	}
	
	@Test
	public function add():Void 
	{
		FlxG.state.add(sprite1);
		FlxG.state.add(sprite2);

		var sprite1Index:Int = FlxArrayUtil.indexOf(FlxG.state.members, sprite1);
		Assert.isTrue(sprite1Index != -1);

		var sprite2Index:Int = FlxArrayUtil.indexOf(FlxG.state.members, sprite2);
		Assert.isTrue(sprite2Index != -1);
	}

	@Test
	public function remove():Void {
		FlxG.state.remove(sprite1);

		var sprite1Index:Int = FlxArrayUtil.indexOf(FlxG.state.members, sprite1);
		Assert.isTrue(sprite1Index == -1);

		FlxG.state.add(sprite1);

		var sprite1Index:Int = FlxArrayUtil.indexOf(FlxG.state.members, sprite1);
		Assert.isTrue(sprite1Index != -1);
	}
	
	@AsyncTest
	public function overlap(factory:AsyncFactory):Void
	{
		Assert.isTrue( FlxG.overlap(sprite1, sprite2) );

		//Move the sprites away from eachother
		sprite1.velocity.x = 2000;
		sprite2.velocity.x = -2000;
		
		var resultHandler:Dynamic = factory.createHandler(this, testOverlap);
		addAsync(resultHandler, 100);
	}

	function testOverlap(?e:Dynamic):Void
	{
		Assert.isFalse( FlxG.overlap(sprite1, sprite2) );
	}

	private function addAsync(handler:Void -> Void, duration:Int):Void
	{
		Timer.delay(function() {
			handler();
		}, duration);
	}

}