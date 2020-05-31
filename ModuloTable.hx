typedef ColourGenerator = Int -> Int -> Int;

class ModuloTable extends h2d.Graphics {
    static public function White(index:Int, count:Int) {
        return 0xFFFFFF;
    }

    static public function Rainbow(index:Int, count:Int) {
        var stringColour = hsluv.Hsluv.hsluvToHex([index *360 / count, 100, 50]);
        return Std.parseInt("0x" + stringColour.substring(1));
    }

    public var count(default, set):Int = 100;
    public var multiplier(default, set):Float = 2.0;
    public var radius(default, set):Int = 100;
    public var colourGenerator(default, set):ColourGenerator = Rainbow;
    public var lineThickness(default, set):Float = 2.0;
    public var lineOpacity(default, set):Float = 0.5;
    var needsUpdate:Bool = true;

    public function set_count(c:Int):Int {
        needsUpdate = true;
        return count = c;
    }

    public function set_multiplier(m:Float):Float {
        needsUpdate = true;
        return multiplier = m;
    }
    public function set_lineThickness(l:Float):Float {
        needsUpdate = true;
        return lineThickness = l;
    }

    public function set_lineOpacity(l:Float):Float {
        needsUpdate = true;
        return lineOpacity = l;
    }

    public function set_radius(r:Int):Int {
        needsUpdate = true;
        return radius = r;
    }

    public function set_colourGenerator(l:ColourGenerator):ColourGenerator {
        needsUpdate = true;
        return colourGenerator = l;
    }

    public function new(?parent) {
        super(parent);
        //filter = true;

        setScale(0.5);
        filter = new h2d.filter.Blur(1.0 / scaleX);
    }

    public function updateTable() {
        var table = [for(i in 0...count) hxd.Math.floor(i * Math.abs(multiplier)) % count];
        var coords = [for(i in 0...count) [
            Math.floor(hxd.Math.sin(2 * Math.PI * i / count) * radius / scaleX),
            Math.floor(hxd.Math.cos(2 * Math.PI * i / count) * radius / scaleY)
        ]];

        clear();

        for(i in 0...count) {
            var start = coords[i];
            var stop = coords[table[i]];
            var colour = colourGenerator(i, count);
            lineStyle(lineThickness / scaleX, colour, lineOpacity);
            moveTo(start[0], start[1]);
            lineTo(stop[0], stop[1]);
        }
    }

    override function draw(ctx) {
        if(needsUpdate) {
            updateTable();
            needsUpdate = false;
        }
        super.draw(ctx);
    }
}