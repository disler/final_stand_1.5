/**
*
* The MIT License
*
* Copyright (c) 2009 Ari Þór (www.flassari.is)
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*
* -----------------------------
* AS3 Class by Julian Garamendy
* -----------------------------
*
*
* Usage 01:
* --------
* var mask_sp:Sprite = new Sprite();
* var pmask:PieMask = new PieMask( mask_sp.graphics, .01, 50, 0, 0, 0, 3 );
*
* mask_sp.graphics.clear();
* mask_sp.graphics.beginFill( 0xFF9900, 1);
* pmask.draw();
* mask_sp.graphics.endFill();
*
*
* Usage 02:
* --------
* var mask_sp:Sprite = new Sprite();
* var pmask:PieMask = new PieMask( mask_sp.graphics, .01, 50, 0, 0, 0, 3 );
* pmask.drawWithFill();
*
*
* Usage 03:
* --------
* var mask_sp:Sprite = new Sprite();
* var pmask:PieMask = new PieMask( mask_sp.graphics, .01, 50, 0, 0, 0, 3 );
* pmask.drawWithFill( 0.75 );
*
*
* Usage 04:
* --------
* var mask_sp:Sprite = new Sprite();
* var pmask:PieMask = new PieMask( mask_sp.graphics, .01, 50, 0, 0, 0, 3 );
* pmask.rotation = Math.PI / 2;
* pmask.percentage = 0.75;
* pmask.drawWithFill( );
*
*
*/
package
{
	import flash.display.Graphics;
	public class PieMask
	{
		public var graphics:Graphics;
		public var percentage:Number;
		public var radius:Number;
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		public var sides:int;
		/**
		* Creates a new PieMask object.
		* Every property can be changed individually after instantiation.
		* The draw() or drawWithFill() methods need to be called for changes to take effect.
		* @param	graphics
		* @param	percentage
		* @param	radius
		* @param	x
		* @param	y
		* @param	rotation
		* @param	sides
		*/
		public function PieMask( graphics:Graphics, percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 6 )
		{
			this.graphics = graphics;
			this.percentage = percentage;
			this.radius = radius;
			this.x = x;
			this.y = y;
			this.rotation = rotation;
			this.sides = sides;
		}
		/**
		* Clears the shapes in graphics and redraws the shape using a solid black fill.
		* @param	percentage - optional. if not provided the percentage property is used
		*/
		public function drawWithFill( percentage:Number = NaN ):void
		{
			graphics.clear();
			graphics.beginFill(0, 1);
			draw(percentage);
			graphics.endFill();
		}
		/**
		* Draws the shape in the provided graphics object.
		* Original algorithm by Ari Þór (www.flassari.is) see license at the begining of the file.
		* @param	percentage - optional. if not provided the percentage property is used
		*/
		public function draw( percentage:Number = NaN ):void
		{
			if (!isNaN(percentage)) this.percentage = percentage;
			
			// graphics should have its beginFill function already called by now
			graphics.moveTo(x, y);

			if (sides < 3) sides = 3; // 3 sides minimum
			
			// Increase the length of the radius to cover the whole target
			var tmp_radius:Number = this.radius;
			tmp_radius /= Math.cos(1 / sides * Math.PI);
			
			// Shortcut function
			var lineToRadians:Function = function(rads:Number):void
			{
				graphics.lineTo(Math.cos(rads) * tmp_radius + x, Math.sin(rads) * tmp_radius + y);
			};
			
			// Find how many sides we have to draw
			var sidesToDraw:int = Math.floor(this.percentage * sides);
			
			for (var i:int = 0; i <= sidesToDraw; i++)
			{
				lineToRadians((i / sides) * (Math.PI * 2) + rotation);
			}
			
			// Draw the last fractioned side
			if (this.percentage * sides != sidesToDraw)
			{
				lineToRadians(this.percentage * (Math.PI * 2) + rotation);
			}
		}
	}
}